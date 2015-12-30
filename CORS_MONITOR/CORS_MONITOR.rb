require 'rubygems'
require 'mechanize'

class CORS_MONITOR
	ID = 'A0099835'
	PD = '123qweASD'
	LOGIN_PAGE = 'https://myaces.nus.edu.sg/cors/StudentLogin'

	@result
	@history
	def initialize
		agent = Mechanize.new
		page = agent.get(LOGIN_PAGE)
		form  = page.forms[0]
		form.fields[1].value = ID
		form.fields[2].value = PD 
		@result = form.submit
		@history = []
	end
	def re_direct_bidding_management
		@result = @result.links[11].click
	end
	def bidding_monitoring
		##module available table
		re_direct_bidding_management
		tmp = @result.search('table.tableframe')[0].search('tr')
		##drop the first and last row
		tmp = tmp.drop(1)
		tmp = tmp.reverse.drop(1).reverse

		# tds = tmp.search('td.listitems')
		module_infos = []
		tmp.each do |tr|
			mod = {}
			tds = tr.search('td.listitems')	
			mod[:timer] = Time.now
			mod[:module_name] = tds[0].text.scan(/\S+/)[0]
			mod[:module_vac] = tds[2].text.scan(/\d+/)[0]
			mod[:bid_num] = tds[4].text.scan(/\d+/)[0]
			mod[:hlbp] = tds[3].text.scan(/\d+/)
			mod[:next_min] = tds[5].text.scan(/\d+/)
			mod[:your_point] = tr.search('input').to_a[2].attributes['value'].to_s.to_i
			module_infos << mod
		end
		module_infos
	end
	def loop
		while(1)
			sleep(10)
			result = bidding_monitoring
			# if(history.empty?)
			# 	history << result
			# else
			# 	tmp = history.last
			# 	if(tmp.count != result.count)
			# 		history << result
			# 	else
			# 		flag = 0;
			# 		tmp.each do |mod|

			# 		end
			# 	end
			# end
			# system 'clear'
			# puts Time.now
			puts result
			puts '='*100
		end
	end
end

cm = CORS_MONITOR.new
cm.re_direct_bidding_management
cm.bidding_monitoring
cm.loop
