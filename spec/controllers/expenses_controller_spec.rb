# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ExpensesController, type: :request do
  let!(:current_user) { create(:user) }

  let(:account) { create(:account) }
  let(:category) { create(:category) }

  let!(:current_expense) { create(:expense, name: 'Expense', value: 10, user_id: current_user.id) }
  let!(:second_expense) { create(:expense) }

  let(:jwt_token) { JsonWebToken.encode(user_id: current_user.id) }
  let(:json) { JSON.parse(response.body) }

  describe '#index' do
    subject { get(expenses_path, headers: { Authorization: jwt_token }) }

    it 'returns all expenses from current user' do
      subject

      expect(response).to have_http_status :ok
      expect(json.count).to eq(1)
      expect(json[0]['name']).to include('Expense')
      expect(json[0]['value_in_cents']).to eq(1000)
      expect(json[0]['paid_at']).to eq('2022-04-28T03:00:00.000Z')
      expect(json[0]['due_at']).to eq('2022-06-21T03:00:00.000Z')
    end

    include_examples 'Invalid JWT Token'
  end

  describe '#show' do
    subject { get(expense_path(slug), headers: { Authorization: jwt_token }) }

    let(:slug) { current_expense.slug }

    context 'with valid params' do
      it 'returns the given expense' do
        subject

        expect(response).to have_http_status :ok
        expect(json['name']).to include('Expense')
        expect(json['value_in_cents']).to eq(1000)
      end
    end

    context 'with params for another user' do
      let(:slug) { second_expense.slug }

      it 'returns errors' do
        subject

        expect(response).to have_http_status :not_found
        expect(json['errors']).to include('Expense not found')
      end
    end

    context 'with invalid params' do
      let(:slug) { 'invalid-slug' }

      it 'returns errors' do
        subject

        expect(response).to have_http_status :not_found
        expect(json['errors']).to include('Expense not found')
      end
    end

    include_examples 'Invalid JWT Token'
  end

  describe '#create' do
    subject { post(expenses_path, headers: { Authorization: jwt_token }, params: params) }

    let(:name) { 'New expense name' }
    let(:value) { 150 }
    let(:due_at) { '05-01-2023 16:20:00' }
    let(:paid_at) { '02-01-2023 12:00:00' }
    let(:account_id) { account.id }
    let(:category_id) { category.id }

    let(:params) do
      {
        name: name,
        value_in_cents: value,
        due_at: due_at,
        paid_at: paid_at,
        account_id: account_id,
        category_id: category_id
      }
    end

    it 'creates a new expense' do
      subject

      expect(response).to have_http_status :created
      expect(json['message']).to include('Expense created with success')
    end

    describe 'with invalid params' do
      context 'without name' do
        let(:name) { nil }

        it 'returns error' do
          subject

          expect(json['errors']).to include("Name can't be blank")
        end
      end

      context 'without value' do
        let(:value) { nil }

        it 'returns error' do
          subject

          expect(json['errors']).to include("Value in cents can't be blank")
        end
      end

      context 'without account' do
        let(:account_id) { nil }

        it 'returns error' do
          subject

          expect(json['errors']).to include('Account must exist')
        end
      end

      context 'without category' do
        let(:category_id) { nil }

        it 'returns error' do
          subject

          expect(json['errors']).to include('Category must exist')
        end
      end
    end

    include_examples 'Invalid JWT Token'
  end

  describe '#update' do
    subject do
      put(expense_path(slug), headers: { Authorization: jwt_token }, params: params)
    end

    let(:slug) { current_expense.slug }

    let(:name) { 'New expense name' }
    let(:value) { 150 }
    let(:due_at) { Time.parse('05-01-2023') }
    let(:paid_at) { Time.parse('02-01-2023') }
    let(:account_id) { account.id }
    let(:category_id) { category.id }

    let(:params) do
      {
        name: name,
        value_in_cents: value,
        due_at: due_at,
        paid_at: paid_at,
        account_id: account_id,
        category_id: category_id
      }
    end

    it 'updates the given expense' do
      subject

      expect(response).to have_http_status :ok
      expect(json['message']).to eq('Expense updated with success')
      expect(current_expense.reload.name).to eq('New expense name')
    end

    context 'with params for another user' do
      let(:slug) { second_expense.slug }

      it 'returns errors' do
        subject

        expect(response).to have_http_status :not_found
        expect(json['errors']).to include('Expense not found')
      end
    end

    describe 'with invalid params' do
      context 'without name' do
        let(:name) { nil }

        it 'returns error' do
          subject

          expect(json['errors']).to include("Name can't be blank")
        end
      end

      context 'without value' do
        let(:value) { nil }

        it 'returns error' do
          subject

          expect(json['errors']).to include("Value in cents can't be blank")
        end
      end

      context 'without account' do
        let(:account_id) { nil }

        it 'returns error' do
          subject

          expect(json['errors']).to include('Account must exist')
        end
      end

      context 'without category' do
        let(:category_id) { nil }

        it 'returns error' do
          subject

          expect(json['errors']).to include('Category must exist')
        end
      end
    end

    include_examples 'Invalid JWT Token'
  end

  describe '#destroy' do
    subject { delete(expense_path(slug), headers: { Authorization: jwt_token }) }

    let(:slug) { current_expense.slug }

    it 'destroys the given expense' do
      subject

      expect(response).to have_http_status :ok
      expect { current_expense.reload }.to raise_error(ActiveRecord::RecordNotFound)
      expect(json['message']).to include('Expense deleted with success')
    end

    context 'with params for another user' do
      let(:slug) { second_expense.slug }

      it 'returns errors' do
        subject

        expect(response).to have_http_status :not_found
        expect(json['errors']).to include('Expense not found')
      end
    end

    context 'with non existing expense' do
      let(:slug) { 'invalid-slug' }

      it 'returns error' do
        subject

        expect(response).to have_http_status :not_found
        expect(json['errors']).to include('Expense not found')
      end
    end

    include_examples 'Invalid JWT Token'
  end
end
