require 'rails_helper'

RSpec.describe DefaultBill, :type => :model do
  let!(:current_user) { create(:user) }

  it "is valid with valid params" do
    expect(DefaultBill.new(name: 'Default Bill', user: current_user)).to be_valid
  end

  it "generates slug" do
    default_bill = DefaultBill.create(name: 'Default Bill', user: current_user)

    expect(default_bill.slug).not_to be_nil
  end
end
