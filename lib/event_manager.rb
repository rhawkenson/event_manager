# -----Iteration 0: Load file and access data-----

# puts "EventManager Initialized!"

# #Use the File.read class and method to access data 
# contents = File.read "event_attendees.csv"
# puts contents 

# File.exist? "event_attendees.csv"


# lines = File.readlines "event_attendees.csv"
# lines.each do |line|
#   next if line == " ,RegDate,first_Name,last_Name,Email_Address,HomePhone,Street,City,State,Zipcode\n"
#   columns = line.split(",")
#   name = columns[2]
#   puts name
# end 

# -----Iteration 1: Parsing with a CSV-----
#Use the built-in Ruby CSV Parser 

# require "csv"

# contents = CSV.open "event_attendees.csv", headers: true, header_converters: :symbol
# contents.each do |row|
#   name = row[:first_name]
#   zipcode = row[:zipcode]
#   puts "#{name} #{zipcode}"
# end 

# -----Iteration 2: Cleaning up zipcodes -----
# Steps to fix zipcode:
#   If the zipcode is >5 digits, reduce the zipcode to the first 5 digits
#   If the zip code is <5 digits, place a 0 at the beginning 
#   If the zipcode is not present, set 00000 as the zipcode

# require "csv"

# def clean_zipcode(zipcode)
#   zipcode.to_s.rjust(5, "0")[0..4] 
# end 

# contents = CSV.open "event_attendees.csv", headers: true, header_converters: :symbol

# contents.each do |row|
#   name = row[:first_name]
#   zipcode = clean_zipcode(row[:zipcode])
#   puts "#{name} #{zipcode}"
# end 

# # -----Iteration 3: Using Google's Civic Information  -----
# require "csv"
# require 'google/apis/civicinfo_v2'

# civic_info = Google::Apis::CivicinfoV2::CivicInfoService.new
# civic_info.key = 'AIzaSyClRzDqDh5MsXwnCWi0kOiiBivP6JsSyBw'


# def clean_zipcode(zipcode)
#   zipcode.to_s.rjust(5, "0")[0..4] 
# end 

# def legislator_by_zipcode(zip)
#   begin 
#     legislators = civic_info.representative_info_by_address(
#                               address: zipcode,
#                               levels: 'country',
#                               roles: ['legislatorUpperBody', 'legislatorLowerBody'])
#     legislators = legislators.officials
    
#     legislator_names = legislators.map(&:name) 
#     legislator_string = legislator_names.join(", ")

#   rescue
#     "You can find your representatives by visiting www.commoncause.org/take-action/find-elected-officials"
#   end
# end

# contents = CSV.open "event_attendees.csv", headers: true, header_converters: :symbol

# contents.each do |row|
#   name = row[:first_name]
#   zipcode = clean_zipcode(row[:zipcode])
#   legislators = legislator_by_zipcode(zipcode)
#     puts "#{name} #{zipcode} #{legislators}"
# end 

# # -----Iteration 4: Form Letters  -----
# template_letter = File.read "form_letter.erb"

# require "csv"
# require 'google/apis/civicinfo_v2'
# require 'erb'

# def clean_zipcode(zipcode)
#   zipcode.to_s.rjust(5, "0")[0..4] 
# end 

# def legislator_by_zipcode(zip)
#   civic_info = Google::Apis::CivicinfoV2::CivicInfoService.new
#   civic_info.key = 'AIzaSyClRzDqDh5MsXwnCWi0kOiiBivP6JsSyBw'

#   begin 
#     civic_info.representative_info_by_address(
#       address: zip,
#       levels: 'country',
#       roles: ['legislatorUpperBody', 'legislatorLowerBody']
#       ).officials
#   rescue
#     "You can find your representatives by visiting www.commoncause.org/take-action/find-elected-officials"
#   end
# end

# def save_thank_you_letter(id,form_letter)
#   Dir.mkdir("output") unless Dir.exists?("output")
#   filename = "output/thanks_#{id}.html"
#   File.open(filename,'w') do |file|
#     file.puts form_letter 
#   end 
# end 

# contents = CSV.open "event_attendees.csv", headers: true, header_converters: :symbol

# template_letter = File.read "form_letter.erb"
# erb_template = ERB.new template_letter

# contents.each do |row|
#   id = row[0]
#   name = row[:first_name]
  
#   zipcode = clean_zipcode(row[:zipcode])
  
#   legislators = legislator_by_zipcode(zipcode)
  
#   form_letter = erb_template.result(binding)
#   save_thank_you_letter(id,form_letter)
# end 

# # -----Iteration 5: Clean Phone Numbers -----

# def clean_phone(phone)
#   phone_arr = phone.split("").select {|num| num.count("0-9") > 0 }.join("")
#   if phone_arr.length > 11
#     return nil
#   elsif phone_arr.length == 11
#     if phone_arr.start_with?("1")
#       phone_arr[1..10]
#     else
#       return nil 
#     end 
#   elsif phone_arr.length < 10
#     return nil 
#   else
#     phone_arr
#   end 
# end 

# require 'csv'
# contents = CSV.open "event_attendees.csv", headers: true, header_converters: :symbol


# contents.each do |row|
#   phone = row[:homephone]
#   phone = clean_phone(phone)
#   puts phone
# end 

# # -----Iteration 6: Time Targetting -----
# require 'csv'
# require 'date'
# contents = CSV.open "event_attendees.csv", headers: true, header_converters: :symbol
# @hourly_arr = Array.new


# def modes(array, find_all=true)
#   histogram = array.inject(Hash.new(0)) { |h, n| h[n] += 1; h }
#   modes = nil
#   histogram.each_pair do |item, times|
#     modes << item if modes && times == modes[0] and find_all
#     modes = [times, item] if (!modes && times>1) or (modes && times>modes[0])
#   end
#   return modes ? modes[1...modes.size] : modes
# end

# contents.each do |row|
#   time = row[:regdate]
#   reg_hour = DateTime.strptime(time, '%D %R').hour
#   @hourly_arr += [reg_hour]
# end 

# puts "The most often hours to register are: #{modes(@hourly_arr)}"

# -----Iteration 7: Day of Week Targetting -----
require 'csv'
require 'date'
contents = CSV.open "event_attendees.csv", headers: true, header_converters: :symbol
@days_arr = Array.new

def modes(array, find_all=true)
  histogram = array.inject(Hash.new(0)) { |h, n| h[n] += 1; h }
  modes = nil
  histogram.each_pair do |item, times|
    modes << item if modes && times == modes[0] and find_all
    modes = [times, item] if (!modes && times>1) or (modes && times>modes[0])
  end
  return modes ? days_to_human_readable(modes[1...modes.size]) : modes
end

def days_to_human_readable(day)
  days_array = ['Sunday','Monday','Tuesday','Wednesday','Thursday','Friday','Saturday']
  days_array[day.join.to_i]
end

contents.each do |row|
  time = row[:regdate]
  reg_day = DateTime.strptime(time, '%D %R').wday
  @days_arr += [reg_day]
end 

puts "The most often day of the week to register is: #{modes(@days_arr)}"



