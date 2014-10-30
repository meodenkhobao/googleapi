class Calendar < Struct.new(:view, :date, :dates, :callback)
  HEADER = %w[SUNDAY MONDAY TUESDAY WEDNESDAY THURSDAY FRIDAY SATURDAY]
  START_DAY = :sunday
  DAYS_IN_WEEK = 7

  delegate :content_tag, to: :view

  def table
    content_tag :table, class: "calendar table table-bordered" do
      header + week_rows
    end
  end

  def header
    content_tag :thead do
      content_tag :tr do
        HEADER.map { |day| content_tag :th, day }.join.html_safe
      end
    end
  end

  def week_rows
    content_tag :tbody do
      weeks.map do |week|
        content_tag :tr do
          week.map { |day| day_cell(day) }.join.html_safe
        end
      end.join.html_safe
    end
  end

  def day_cell day
    content_tag :td, view.capture(day, date.month, &callback), class: class_of(day)
  end

  def class_of day
    if day == Date.current
      "info"
    elsif day.in?(dates) && day.month == date.month
      "success"
    end
  end

  def weeks
    first = date.beginning_of_month.beginning_of_week(START_DAY)
    last = date.end_of_month.end_of_week(START_DAY)
    (first..last).to_a.in_groups_of(DAYS_IN_WEEK)
  end
end