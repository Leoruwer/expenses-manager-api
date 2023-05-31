# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Reports::GroupsController, type: :request do
  let!(:current_user) { create(:user) }
  let!(:another_user) { create(:user) }

  let(:jwt_token) { JsonWebToken.encode(user_id: current_user.id) }
  let(:json) { JSON.parse(response.body).dig('2023', '6', 'expenses') }

  let(:current_expense) { create(:expense, user_id: current_user.id, due_at: Date.new(2023, 6, 21)) }
  let(:another_expense) { create(:expense, name: 'Expense', user_id: another_user.id, due_at: Date.new(2023, 6, 28)) }
  let(:another_month_expense) { create(:expense, user_id: current_user.id, due_at: Date.new(2023, 4, 21)) }

  before do
    current_expense.reload
    another_expense.reload
    current_user.reload
  end

  describe '#show' do
    context 'when year/month belongs to expense' do
      subject { get(reports_path(2023, 6), headers: { Authorization: jwt_token }) }

      it 'return expenses from user' do
        subject

        expect(response).to have_http_status :ok
        expect(json.count).to eq 1
        expect(json[0]['name']).to eq current_expense.name
      end

      it "doesn't return expenses from another user" do
        subject

        expect(response).to have_http_status :ok
        expect(json[0]['name']).not_to eq another_expense.name
      end
    end

    context "when year/month doesn't belongs to expense" do
      subject { get(reports_path(2023, 5), headers: { Authorization: jwt_token }) }

      it "doesn't return any expense" do
        subject

        expect(json).to be_nil
      end
    end
  end
end
