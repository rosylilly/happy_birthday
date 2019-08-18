class Character < ApplicationRecord
  belongs_to :work

  enum gender: {
    unknown: 0,
    male: 1,
    female: 2,
  }

  validates :name, presence: true, length: { maximum: 255 }
  validates :name_kana, length: { maximum: 255, allow_blank: true }
  validates :birth_month, inclusion: { in: (1..12) }
  validates :birth_day, inclusion: { in: (1..31) }

  def birth_year
    current = Time.current
    year = current.year
    year -= 1 if current.end_of_day < Date.new(year, birth_month, birth_day)
    year
  end

  def birthday
    Date.new(birth_year, birth_month, birth_day)
  rescue ArgumentError
    day = 28 if birth_month == 2 && (29..30).includes?(birth_day)
    Date.new(birth_year, birth_month, day)
  end

  def ical_event
    @ical_event ||= begin
      event = ::Icalendar::Event.new
      event.created = created_at
      event.summary = "#{name} [#{work.title}]"
      event.description = [
        "#{birth_month} / #{birth_day}",
        work.title,
        name,
      ].join("\n")
      event.dtstart = ::Icalendar::Values::Date.new(birthday)
      event.dtstamp = created_at
      event.last_modified = updated_at
      event.uid = id.to_s
      event.rrule = 'FREQ=YEARLY'
      event.alarm do |a|
        a.action  = "DISPLAY"
        a.summary = "#{name}"
        a.trigger = "-PT15M"
      end

      event
    end
  end
end
