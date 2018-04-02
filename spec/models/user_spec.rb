require 'rails_helper'

describe User do
  let(:user) { FactoryBot.create(:user, :user_confirmed, :customer ) }
end
