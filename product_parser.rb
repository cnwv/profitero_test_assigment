require 'nokogiri'
require 'curb'
require 'byebug'

class ProductParser
  attr_accessor :url, :items

  def initialize(url)
    @url = url
    @items = []
  end

  def parse
    doc = load_page(url)
    get_product_data(doc)
    items
  end

  private

  def get_product_data(doc)
    product_name = doc.css('//*[@id="center_column"]/div/div[2]/div[1]/div[1]/p').text
    image_url = doc.at_xpath('//*[@id="bigpic"]')['src']
    attribute_list = doc.xpath('//fieldset//ul/li')

    attribute_list.each_with_index do |item, ind|
      product_weight = item.xpath('//*[@class="radio_label"]')[ind].text
      price = item.xpath('//*[@class="price_comb"]')[ind].text
      full_product_name = "#{product_name} - #{product_weight}"
      items << [full_product_name, price, image_url]
    end
  end

  def load_page(url)
    sleep(0.2)
    puts "Curl product link #{url}"
    http = Curl.get(url)
    Nokogiri::HTML(http.body_str)
  end
end
