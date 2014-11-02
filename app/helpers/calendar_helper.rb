module CalendarHelper
  def calendar date = Date.today, dates, &block
    Calendar.new(self, date, dates, block).table
  end

  def link_to_prev_month
    disabled = @date.beginning_of_month == @first_date.beginning_of_month
    link_to '#', class: "btn btn-default prev-month", disabled: disabled do
      "&larr;".html_safe
    end
  end

  def link_to_today
    link_to 'Today', '#', class: "btn btn-primary today"
  end

  def link_to_next_month
    disabled = @date.end_of_month == @last_date.end_of_month
    link_to '#', class: "btn btn-default next-month", disabled: disabled do
      "&rarr;".html_safe
    end
  end

  def date_cell date, month
    content_tag :div, class: "calendar-cell" do
      if date.month != month
        content_tag :div, class: "not-month" do
          content_tag :p, date.day
        end
      else
        events = @events.select { |e| e[:start_time].to_date == date }
        e = events.first
        if e
          (content_tag :p, date.day) +
          (content_tag :div, class: "with-event", "data-toggle" => "popover",
            title: date.strftime("%B %d, %Y"), "data-content" => event_list(events) do
            content_tag :ul do
              (content_tag :li, "#{e[:start_time].strftime("%H:%M")}-#{e[:end_time].strftime("%H:%M")}") + "#{e[:summary]}"
            end
          end)
        else
          content_tag :p, date.day
        end
      end
    end
  end

  def event_list events
    content_tag :ul do
      events.map do |e|
        (content_tag :li, "#{e[:start_time].strftime("%H:%M")}-#{e[:end_time].strftime("%H:%M")}") +
        (link_to e[:summary], e[:link])
      end.join
    end
  end
end
