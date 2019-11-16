require 'rails_helper'

describe Order do

  let(:order) { FactoryBot.create(:order) }
  before { ActiveJob::Base.queue_adapter = :test }


  describe 'constants' do
    it "is expected to have time format constant" do
      expect(Order::TIME_FORMAT).to eq("%I:%M%p")
    end

    it "is expected to have preparation time constant" do
      expect(Order::PREPARATION_TIME).to eq(1800)
    end
  end

  describe 'included module' do
    it "is expected to have included token generator" do
      expect(Order.ancestors.include?(TokenGenerator)).to eq(true)
    end
  end

  describe 'delegations' do
    it "is expected to respond to branch_name" do
      expect(Order.new).to respond_to(:branch_name)
    end

    it "is expected to respond to branch_address" do
      expect(Order.new).to respond_to(:branch_address)
    end

    it "is expected to respond to branch_contact_number" do
      expect(Order.new).to respond_to(:branch_contact_number)
    end
  end

  describe 'associations' do
    it { is_expected.to have_one(:charge).dependent(:destroy) }
    it { is_expected.to belong_to(:cart) }
    it { is_expected.to belong_to(:user) }
    it { is_expected.to belong_to(:branch) }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:phone_number) }
    it { is_expected.to validate_presence_of(:pick_up) }
    it { is_expected.to allow_value('9654208158').for(:phone_number) }
    it { is_expected.not_to allow_value('965420815').for(:phone_number) }

  end

  describe 'custom validations' do
    it { is_expected.to callback(:valid_pick_up_time?).before(:validate).if(:pick_up?) }
    it { is_expected.to callback(:sufficient_preparation_time?).before(:validate).if(:pick_up?) }
    it { is_expected.to callback(:past_pick_up?).before(:validate).if(:pick_up?) }
  end

  describe 'callback' do
    it { is_expected.to callback(:send_confirmation_mail).after(:commit).on(:create) }
  end

  describe 'scope' do
    describe 'by_date' do
      it "is expected to by default return orders created in last 7 days" do
        expect(Order.by_date).to include(order)
      end

      it "is expected to return orders created between time given" do
        expect(Order.by_date(2.month.ago , 1.month.ago)).not_to include(order)
      end
    end
  end

  describe 'Instance Public Methods' do
    describe 'delivered' do
      let(:order_picked_status) { order.picked }
      it 'is expected to change the picked status of order' do
        expect { order.delivered }.to change { order.picked }.from(order_picked_status).to(!order_picked_status)
      end

      it "is expected to set the feedback digest token" do
        expect { order.delivered }.to change { order.feedback_digest }
      end

      it "is expected to set the feedback email sent at" do
        expect { order.delivered }.to change { order.feedback_email_sent_at }
      end

      it "is expected to increase the enqueued jobs count of order mailer" do
        expect { order.delivered }.to change { ActiveJob::Base.queue_adapter.enqueued_jobs.count }.by(5)
      end
    end

    describe 'prepared' do
      let(:order_ready_status) { order.ready }
      it "is expected to change the prepared status of the order" do
        expect { order.prepared }.to change { order.ready }.from(order_ready_status).to(!order_ready_status)
      end
    end

    describe 'feedback_submitted' do
      before { order.update_column(:feedback_digest, 'sfasdfsfas') }
      it "is expected to set the feedback digest token and feedback email sent at to nil" do
        expect { order.feedback_submitted }.to change { order.feedback_digest }.from('sfasdfsfas').to(nil)
      end

      let(:time) { Time.current }
      before { order.update_column(:feedback_email_sent_at, time ) }
      it "is expected to set the feedback email sent at feedback to nil" do
        expect { order.feedback_submitted }.to change { order.feedback_email_sent_at }.from(time).to(nil)
      end
    end

    describe 'feedback_link_expired' do
      context "when feedback email sent at is less than 1 day" do
        before { order.update_column(:feedback_email_sent_at, 1.hour.ago ) }
        it "is expected to return false" do
          expect(order.feedback_link_expired?).to eq(false)
        end
      end

      context "when feedback email sent at is more than 1 day" do
        before { order.update_column(:feedback_email_sent_at, 2.day.ago ) }
        it "is expected to return true " do
          expect(order.feedback_link_expired?).to eq(true)
        end
      end
    end

    describe 'cancellable?' do
      context "when current time is more than half an hour of pick up time" do
        before { order.update_column(:pick_up, 1.hour.from_now) }
        it "is expected to return true" do
          expect(order.cancellable?).to eq(true)
        end
      end

      context "when current time is less than half an hour of pick up time" do
        before { order.update_column(:pick_up, 10.minutes.ago) }
        it "is expected to return false" do
          expect(order.cancellable?).to eq(false)
        end
      end
    end

    describe 'affect ingredient' do
      context "when order is cancelled" do
        it "is expected to increase the inventory" do
          expect{ order.affect_ingredient("+") }.to change { order.branch.inventories.find_by(ingredient_id: order.cart.line_items.first.meal.ingredients.first.id).quantity }.by(1)
        end
      end

      context "when order is placed" do
        it "is expected to increase the inventory" do
          expect{ order.affect_ingredient("-") }.to change { order.branch.inventories.find_by(ingredient_id: order.cart.line_items.first.meal.ingredients.first.id).quantity }.by(-1)
        end
      end
    end

    describe 'sufficient stock' do
      context "when sufficient stock is present in inventory" do
        it "is expected to return true " do
          expect(order.sufficient_stock).to eq(true)
        end
      end

      context "when stock is insufficient in inventory" do
        before { order.branch.inventories.first.update_column(:quantity, 0) }
        it "is expected to return false" do
          expect(order.sufficient_stock).to eq(false)
        end
      end
    end
  end

  describe 'class Method' do
    describe 'most sold meal' do
      it "is expected to return the id of the most sold meal" do
        expect(Order.most_sold_meal(Order.all)).to eq(6)
      end
    end
  end

  describe 'Instance private methods' do
    describe 'sufficient_preparation_time?' do
      context "when sufficient preparation time is not provided" do
        let(:order_with_insufficient_preparation_time) { Order.new(pick_up: 20.minutes.from_now, branch: Branch.first) }
        before { order_with_insufficient_preparation_time.valid? }
        it "is expected to show error" do
          expect(order_with_insufficient_preparation_time.errors[:pick_up]).to include("require half an hour to prepare order")
        end
      end

      context "when sufficient preparation time is provided" do
        let(:order_with_sufficient_preparation_time) { Order.new(pick_up: 2.hours.from_now, branch: Branch.first) }
        before { order_with_sufficient_preparation_time.valid? }
        it "is expected not to show error" do
          expect(order_with_sufficient_preparation_time.errors[:pick_up]).not_to include("require half an hour to prepare order")
        end
      end
    end

    describe 'past_pick_up?' do
      context "when pick up time is before the current time" do
        let(:order_with_past_pick_up) { Order.create(pick_up: 1.hour.ago, branch: Branch.first ) }
        it "is expected to show error if " do
          expect(order_with_past_pick_up.errors[:pick_up]).to include("already past this time. Please Enter a time in future")
        end
      end

      context "when pick up time is ahead the current time" do
        let(:order_with_future_pick_up) { Order.create(pick_up: 1.hour.from_now, branch: Branch.first ) }
        it "is expected not to show error" do
          expect(order_with_future_pick_up.errors[:pick_up]).not_to include("already past this time. Please Enter a time in future")
        end
      end
    end

    describe 'valid_pick_up_time?' do
      context "when pick up time is not between branch timings" do
        let(:order_with_invalid_pick_up) { Order.create(pick_up: Branch.first.opening_time - 30.minutes, branch: Branch.first ) }
        it "is expected to show error is " do
          expect(order_with_invalid_pick_up.errors[:pick_up]).to include("pick up a time between branch timings")
        end
      end

      context "when pick up time is between branch timings" do
        let(:order_with_valid_pick_up) { Order.create(pick_up: Branch.first.opening_time + 31.minutes, branch: Branch.first ) }
        it "is expected not to show error" do
          expect(order_with_valid_pick_up.errors[:pick_up]).not_to include("pick up a time between branch timings")
        end
      end
    end

    describe 'feedback_token' do
      it "is expected to set the feedback_digest" do
        expect { order.send(:feedback_token) }.to change { order.feedback_digest }
      end

      it "is expected to set the feedback email sent at" do
        expect { order.send(:feedback_token) }.to change { order.feedback_email_sent_at }
      end
    end

    describe 'send_confirmation_mail' do
      it "is expected to send the confirmaton mail to user" do
        expect { order.send :send_confirmation_mail }.to change { ActiveJob::Base.queue_adapter.enqueued_jobs.count }.by(5)
      end
    end
  end
end
