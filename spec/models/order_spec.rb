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
      it 'is expected to change the picked status of order' do
        order_deliver_status = order.picked
        order.delivered
        expect(order.picked).to eq(!order_deliver_status)
      end

      it "is expected to set the feedback digest token and feeback email sent at" do
        feedback_digest = order.feedback_digest
        feedback_email_sent_at = order.feedback_email_sent_at
        order.delivered
        expect(order.feedback_digest).not_to eq(feedback_digest)
        expect(order.feedback_email_sent_at).not_to eq(feedback_email_sent_at)
      end

      it "is expected to increase the enqueued jobs count of order mailer" do
        expect { order.delivered }.to change { ActiveJob::Base.queue_adapter.enqueued_jobs.count }.by(5)
      end
    end

    describe 'prepared' do
      it "is expected to change the prepared status of the order" do
        order_ready_status = order.picked
        order.prepared
        expect(order.ready).to eq(!order_ready_status)
      end
    end

    describe 'feedback_submitted' do
      it "is expected to set the feedback digest token and feedback email sent at to nil" do
        order.update_columns(feedback_digest: 'sfasdfsfas', feedback_email_sent_at: Time.current)
        order.feedback_submitted
        expect(order.feedback_email_sent_at).to eq(nil)
        expect(order.feedback_email_sent_at).to eq(nil)
      end
    end

    describe 'feedback_link_expired' do
      it "is expected to return true if the feedback email sent at is less than 1 day" do
        order.update_column(:feedback_email_sent_at, 1.hour.ago )
        expect(order.feedback_link_expired?).to eq(false)
      end

      it "is expected to return false if the feedback email sent at is less than 1 day" do
        order.update_column(:feedback_email_sent_at, 2.day.ago )
        expect(order.feedback_link_expired?).to eq(true)
      end
    end

    describe 'cancellable?' do
      it "is expected to return true if the current time is more than half an hour of pick up time" do
        order.update_column(:pick_up, 1.hour.from_now)
        expect(order.cancellable?).to eq(true)
      end

      it "is expected to return false if the current time is less than half an hour of pick up time" do
        order.update_column(:pick_up, 10.minutes.ago)
        expect(order.cancellable?).to eq(false)
      end
    end

    describe 'sufficient stock' do
      it "is expected to return true if sufficient stock is present in inventory" do
        expect(order.sufficient_stock).to eq(true)
      end

      it "is expected to return false if stock is insufficient" do
        order.branch.inventories.first.update_column(:quantity, 0)
        expect(order.sufficient_stock).to eq(false)
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
      it "is expected to show error if sufficient preparation time is not provided" do
        order_with_insufficient_preparation_time = Order.new(pick_up: 20.minutes.from_now, branch: Branch.first)
        expect(order_with_insufficient_preparation_time.valid?).to eq(false)
        expect(order_with_insufficient_preparation_time.errors[:pick_up]).to include("require half an hour to prepare order")
      end

      it "is expected not to show error if sufficient preparation time is not provided" do
        order_with_sufficient_preparation_time = Order.new(pick_up: 2.hours.from_now, branch: Branch.first)
        order_with_sufficient_preparation_time.valid?
        expect(order_with_sufficient_preparation_time.errors[:pick_up]).not_to include("require half an hour to prepare order")
      end
    end

    describe 'past_pick_up?' do
      it "is expected to show error if pick up time is before the current time" do
        order_with_past_pick_up = Order.new(pick_up: 1.hour.ago, branch: Branch.first )
        expect(order_with_past_pick_up.valid?).to eq(false)
        expect(order_with_past_pick_up.errors[:pick_up]).to include("already past this time. Please Enter a time in future")
      end

      it "is expected not to show error if pick up time is ahead the current time" do
        order_with_future_pick_up = Order.new(pick_up: 1.hour.from_now, branch: Branch.first )
        order_with_future_pick_up.valid?
        expect(order_with_future_pick_up.errors[:pick_up]).not_to include("already past this time. Please Enter a time in future")
      end
    end

    describe 'valid_pick_up_time?' do
      it "is expected to show error is pick up time is not between branch timings" do
        order_with_invalid_pick_up = Order.new(pick_up: Branch.first.opening_time - 30.minutes, branch: Branch.first )
        expect(order_with_invalid_pick_up.valid?).to eq(false)
        expect(order_with_invalid_pick_up.errors[:pick_up]).to include("pick up a time between branch timings")
      end

      it "is expected not to show error is pick up time is between branch timings" do
        order_with_valid_pick_up = Order.new(pick_up: Branch.first.opening_time + 31.minutes, branch: Branch.first )
        order_with_valid_pick_up.valid?
        expect(order_with_valid_pick_up.errors[:pick_up]).not_to include("pick up a time between branch timings")
      end
    end

    describe 'feedback_token' do
      it "is expected to set the feedback_digest and feedback_email_sent_at" do
        feedback_digest = order.feedback_digest
        feedback_email_sent_at = order.feedback_email_sent_at
        order.send(:feedback_token)
        expect(order.feedback_digest).not_to eq(feedback_digest)
        expect(order.feedback_email_sent_at).not_to eq(feedback_email_sent_at)
      end
    end

    describe 'send_confirmation_mail' do
      it "is expected to send the confirmaton mail to user" do
        expect { order.send :send_confirmation_mail }.to change { ActiveJob::Base.queue_adapter.enqueued_jobs.count }.by(5)
      end
    end
  end
end
