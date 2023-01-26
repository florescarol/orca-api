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
        categories: earnings.group_by(&:category).map do |category, earnings|
          {
            name: category.name,
            total_amount: number_to_currency_br(earnings.sum(&:amount)),
            earnings: earnings.map do |earning|
              {
                id: earning.id,
                name: earning.name,
                amount: number_to_currency_br(earning.amount),
                date: format_date(earning.date),
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