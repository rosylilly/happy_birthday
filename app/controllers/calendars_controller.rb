class CalendarsController < ApplicationController
  def ical
    calendar.append_custom_property("X-WR-CALNAME;VALUE=TEXT", "ハッピーバースデー")
    characters.find_in_batches(batch_size: 500) do |batch|
      batch.each do |character|
        calendar.add_event(character.ical_event)
      end
    end
    calendar.publish
    headers["Content-Type"] = "text/calendar; charset=UTF-8"
    render plain: calendar.to_ical
  end

  def json
    events = []

    characters.find_in_batches(batch_size: 500) do |batch|
      batch.each do |character|
        events << {
          title: "#{character.name} [#{character.work.title}]",
          start: character.birthday.strftime("%Y-%m-%d"),
          allDay: true,
        }
      end
    end

    render json: events
  end

  private

  def calendar
    @calendar ||= ::Icalendar::Calendar.new
  end

  def characters
    @characters ||= Character.eager_load(:work).female
  end
end
