class UsersController < ApplicationController
  before_action :load_objects, only: [:googleplus, :gmail, :calendar]

  def index
  end

  def googleplus
    plus = @client.discovered_api('plus')
    @friends = @client.execute(api_method: plus.people.list,
      parameters: {userId: 'me', collection: 'visible'}).data.items

    respond_to do |format|
      format.js
    end
  end

  def gmail
    gmail = @client.discovered_api('gmail')
    thread_list = @client.execute(api_method: gmail.users.threads.list,
      parameters: {userId: 'me', maxResults: 10}).data.threads
    @threads = []
    thread_list.each do |thread|
      data = @client.execute(api_method: gmail.users.threads.get, parameters:
        {userId: 'me', id: thread.id, fields: "messages(historyId,payload)"})
        .data.messages.first.payload.headers
      h = {}
      data.select{|d| d.name.in?(["From", "Date", "Subject"])}.each do |d|
        h[d.name] = d.value
      end
      @threads << h
    end
  end

  def calendar
    calendar = @client.discovered_api('calendar', 'v3')
    calendars = @client.execute(api_method: calendar.calendar_list.list,
      parameters: {fields: "items/id"}).data.items
    @events = []
    calendars.each do |cal|
      events = @client.execute(api_method: calendar.events.list,
        parameters: {fields: "items(created,end,htmlLink,start,summary)",
        calendarId: cal.id}).data.items
      @events += events.map do |event|
        {
          start_time: (event.start.try(:[], 'dateTime') ||
            event.start.try(:[], 'date').try(:to_time) || event.created).localtime,
          end_time: (event.end.try(:[], 'dateTime') ||
            event.end.try(:[], 'date').try(:to_time) || event.created).localtime,
          summary: event.summary,
          link: event.htmlLink
        }
      end
    end
    @events.sort_by!(&:first).reverse!
  end

  private

  def load_objects
    @user = User.find params[:id]
    raise ActiveRecord::RecordNotFound unless current_user == @user
    @client = @user.google_client
  end
end