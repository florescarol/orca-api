class EarningsReportsPresenter < BasePresenter

  def initialize(earnings:)
    @earnings = earnings
  end

  def group_by_categories
    @earnings.sort_by(&:date).group_by(&:category_group).map do |group, earnings|
      {
        title: group.title,
        color: group.color,
        total_amount: number_to_currency_br(earnings.sum(&:amount)),
        total_amount_percentage: (earnings.sum(&:amount).to_f / @earnings.sum(&:amount) * 100).round(2),
        categories: earnings.group_by(&:category).map do |category, earnings|
          {
            name: category.name,
            total_amount: number_to_currency_br(earnings.sum(&:amount)),
            total_amount_percentage: (earnings.sum(&:amount).to_f / @earnings.sum(&:amount) * 100).round(2),
            earnings: earnings.map do |earning|
              {
                id: earning.id,
                name: earning.name,
                amount: number_to_currency_br(earning.amount),
                # TO DO: change amount_value to amount
                # and amount to formatted_amount
                # [ cant change now because of old frontend ]
                amount_value: earning.amount,
                date: format_date(earning.date),
                category_id: earning.category_id,
                category_name: earning.category_name,
                category_group: earning.category_group_title
              }
            end
          }
        end
      }
    end
  end

end