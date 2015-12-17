# coding:utf-8
require_relative './web_scraping.rb'
require_relative './beauty_parser.rb'


parser = BeautyParser.new

WebScraping.new(parser).load()
