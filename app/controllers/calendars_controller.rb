class CalendarsController < ApplicationController
  def ical
    return unless stale?(characters, public: true)

    ics = cache([:ics, characters.cache_key]) do
      calendar.append_custom_property("X-WR-CALNAME;VALUE=TEXT", "ハッピーバースデー")
      characters.find_in_batches(batch_size: 500) do |batch|
        batch.each do |character|
          calendar.add_event(character.ical_event)
        end
      end
      calendar.publish
      calendar.to_ical
    end

    headers["Content-Type"] = "text/calendar; charset=UTF-8"
    render plain: ics
  end

  def json
    return unless stale?(characters, public: true)

    json = cache([:json, characters.cache_key]) do
      events = []
      characters.find_in_batches(batch_size: 500) do |batch|
        batch.each do |character|
          events << {
            title: "#{character.name} [#{character.work.title}]",
            start: character.birthday.strftime("%Y-%m-%d"),
            allDay: true,
            rrule: {
              freq: 'yearly',
              interval: 1,
              dtstart: character.birthday.strftime("%Y-%m-%dT00:00:00"),
            },
          }
        end
      end
      events
    end

    render json: json
  end

  private

  def calendar
    @calendar ||= ::Icalendar::Calendar.new
  end

  def characters
    @characters ||= Character.eager_load(:work).female
  end
end
