class Work::CharaJob < ApplicationJob
  attr_reader :work

  # ex: https://schara.sunrockgo.com/media?m=0p9h0w
  # ex: Work::CharaJob.perform_now('https://schara.sunrockgo.com/media?m=0p9h0w')
  def perform(url)
    document = fetch(url)
    title = document.css('#media_data > h2 > cite').text.strip

    @work = Work.find_or_create_by!(title: title)

    import_characters(document)
  end

  private

  def fetch(url)
    Rails.logger.debug("fetch: #{url}")
    html = `curl -sL "#{url}"`

    Nokogiri::HTML.parse(html, nil, 'utf-8')
  end

  def import_characters(doc)
    doc.css('#chara_list > .wrap_chara').each do |div|
      name = div.css('.chara_name .main_name').text.strip
      name_kana = div.css('.chara_name .name_kana').text.strip
      name_kana = name if name_kana.blank?
      next if name.blank?

      bd = div.css('table tbody tr:nth-child(1) td a').text
      birth_month = bd.gsub(/月\d+日/, '').to_i
      birth_day = bd.gsub(/^\d+月|日/, '').to_i

      gender = :unknown
      gender = :male if div.css('table tbody tr:nth-child(2) td').text.strip == '男'
      gender = :female if div.css('table tbody tr:nth-child(2) td').text.strip == '女'

      character = Character.find_or_initialize_by(work: work, name: name)
      character.assign_attributes(name_kana: name_kana, birth_month: birth_month, birth_day: birth_day, gender: gender)
      character.save!
    end
  end
end
