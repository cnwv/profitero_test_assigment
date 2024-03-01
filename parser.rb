require 'nokogiri'
require 'curb'
require 'csv'
require_relative 'product_parser'

class Parser
  HEADERS = %w[title price image_url].freeze

  attr_accessor :url, :items, :current_page, :total_pages

  def initialize(url, file)
    @url = url
    @file = file
    @items = []
    @current_page = 1
    @total_pages = nil


  end

  def run
    get_items
    CSV.open(@file, "wb", write_headers: true, headers: HEADERS) do |csv|
      items.each do |item|
        item.each {|element| csv << element}
      end
    end
    puts "Task is finished"
  end

  private

  def get_items
    doc = load_page(url)
    get_quantity_pages(doc)
    product_links = get_product_links(doc)
    product_links.each do |link|
      items.push ProductParser.new(link).parse
    end

    while has_next_page?
      @current_page += 1
      doc = load_page("#{url}?p=#{current_page}")
      product_links = get_product_links(doc)
      product_links.each { |link| @items << ProductParser.new(link).parse }
    end
  end

  def has_next_page?
    current_page <= total_pages
  end


  def get_quantity_pages(doc)
    input_element = doc.at("//input[@name='n' and @id='nb_item_bottom']")
    value = input_element['value'].to_i
    @total_pages = (value.to_f / 24).ceil
  end

  def get_product_links(doc)
    products = doc.css('.product-desc a')
    links = products.map { |link| link['href'] }
  end

  def load_page(url)
    puts "Curl products link #{url}"
    http = Curl.get(url)
    Nokogiri::HTML(http.body_str)
  end
end
