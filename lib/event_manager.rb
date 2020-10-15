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

# -----Iteration 4: Form Letters  -----
template_letter = File.read "form_letter.erb"

require "csv"
require 'google/apis/civicinfo_v2'
require 'erb'

def clean_zipcode(zipcode)
  zipcode.to_s.rjust(5, "0")[0..4] 
end 

def legislator_by_zipcode(zip)
  civic_info = Google::Apis::CivicinfoV2::CivicInfoService.new
  civic_info.key = 'AIzaSyClRzDqDh5MsXwnCWi0kOiiBivP6JsSyBw'

  begin 
    civic_info.representative_info_by_address(
      address: zip,
      levels: 'country',
      roles: ['legislatorUpperBody', 'legislatorLowerBody']
      ).officials
  rescue
    "You can find your representatives by visiting www.commoncause.org/take-action/find-elected-officials"
  end
end

def save_thank_you_letter(id,form_letter)
  Dir.mkdir("output") unless Dir.exists?("output")
  filename = "output/thanks_#{id}.html"
  File.open(filename,'w') do |file|
    file.puts form_letter 
  end 
end 

contents = CSV.open "event_attendees.csv", headers: true, header_converters: :symbol

template_letter = File.read "form_letter.erb"
erb_template = ERB.new template_letter

contents.each do |row|
  id = row[0]
  name = row[:first_name]
  
  zipcode = clean_zipcode(row[:zipcode])
  
  legislators = legislator_by_zipcode(zipcode)
  
  form_letter = erb_template.result(binding)
  save_thank_you_letter(id,form_letter)
end 

# -----Iteration 5: Clean Phone Numbers -----
def clean_phone(phone)
  phone.to_s.rjust(11, '0')[1..10]
end 

contents.each do |row|
  phone = row[:HomePhone]
  phone = clean_phone(phone)
  puts phone
end 



