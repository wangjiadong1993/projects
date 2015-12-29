require 'rubygems'
require 'mechanize'
require 'open-uri'
require 'nokogiri'
class Bilibili_Movie_Achive
	#constants
	##the three parts of the url
	PAGE_NAME_PART_1 = 'http://www.bilibili.com/video/'
	PAGE_NAME_PART_2 = '.html#!page='
	PAGE_NAME_PART_3 = '&order=default'
	#instance parameters
	#west, chiese, or other something
	@movie_type = 'movie_west_1'
	#the sythsized url
	@page_name = ''
	#the index of the page
	@page_num = 1
	#the amount of pages
	@total_page = 0

	@agent
	#items obtained from the page
	@total_items = []
	#constructor
	def initialize
		@page_num = 1
		@page_name = ''
		@movie_type = 'movie_west_1'
		@total_items= []
	end
	#helpers
	#synthesize the url
	def url_generator
		@page_name = PAGE_NAME_PART_1 + @movie_type + PAGE_NAME_PART_2 + @page_num.to_s + PAGE_NAME_PART_3
	end
	#check whether it is out of the boundary
	def page_num_checker 
		@page_num < @total_page || @total_page == 0
	end
	##get the pager number from custom-right-inner class
	def page_num_getter
		##Nokogiri
		# doc = Nokogiri::HTML(open(@page_name))
		# puts doc.css('result custom-right-inner')
		##Mechanize
		##new agent
		@agent = Mechanize.new
		str =  @agent.get(@page_name).search('span.custom-right-inner')[0].text
		@total_page = str.scan(/\d+/)[0].to_i
	end
	##get all the items on the page
	def list_getter
		@total_items = @agent.get(@page_name).search('div.l-item')
	end
	def op_per_item

	end
	def page_incrementer
		@page_num = @page_num + 1;
	end
end 

#url generated
bi = Bilibili_Movie_Achive.new

bi.url_generator
# puts @page_name
bi.page_num_getter

# puts bi.total_page_num
while(bi.page_num_checker)
	bi.list_getter

	bi.page_incrementer
end





