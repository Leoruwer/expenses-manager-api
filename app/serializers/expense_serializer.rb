class ExpenseSerializer < ActiveModel::Serializer
  attributes :id, :name, :slug, :value_in_cents, :is_paid, :due_at, :paid_at

  belongs_to :account
  belongs_to :category

  def is_paid
    object.paid_at.present?
  end

  def due_at
    date_format(object.due_at)
  end

  def paid_at
    date_format(object.paid_at) if is_paid
  end

  def account
    {
      id: object.account.id,
      name: object.account.name
    }
  end

  def category
    {
      id: object.category.id,
      name: object.category.name
    }
  end

  private

  def date_format(date)
    {
      day: date.day,
      month: date.month,
      year: date.year,
      month_name: date.strftime("%B"),
      date: date
    }
  end
end
