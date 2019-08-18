require 'kconv'

class Work::ImportJob < ApplicationJob
  queue_as :default

  attr_reader :work

  def perform(url)
    doc = fetch(url)
    title = doc.xpath('/html/body/div[3]/div[1]/h5[1]').text.strip

    @work = Work.find_or_create_by!(title: title)

    importing = true
    while importing do
      importing = false
      import_characters(doc)

      doc.css('body > center > a').each do |footer_link|
        if footer_link.text.strip == '次ページ→'
          importing = true
          doc = fetch(footer_link.attribute('href').value)
        end
      end

      sleep 1
    end

    nil
  end

  private

  def fetch(url)
    Rails.logger.debug("fetch: #{url}")
    html = `curl -sL "#{url}"`.toutf8

    Nokogiri::HTML.parse(html, nil, 'utf-8')
  end

  def import_characters(doc)
    doc.css('#contents > div[id="main"] > div').each do |div|
      name = div.css('h4 ruby rb').text.strip
      name_kana = div.css('h4 ruby rt').text.strip
      next if name.blank?

      birth_month, birth_day = *div.css('ul > li:first-child > p').text.split('/', 2).map(&:to_i)

      gender = :unknown
      gender = :male if div.css('ul > li:nth-child(2) > p').text.strip == '男性'
      gender = :female if div.css('ul > li:nth-child(2) > p').text.strip == '女性'

      character = Character.find_or_initialize_by(work: work, name: name)
      character.assign_attributes(name_kana: name_kana, birth_month: birth_month, birth_day: birth_day, gender: gender)
      character.save!
    end
  end
end
