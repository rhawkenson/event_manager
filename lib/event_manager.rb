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
#   if zipcode.nil?
#     "00000"
#   elsif zipcode.length < 5
#     zipcode.rjust(5, "0")
#   elsif zipcode.length > 5
#     zipcode.slice[0..4]
#   else 
#     zipcode
#   end 
# end 

# contents = CSV.open "event_attendees.csv", headers: true, header_converters: :symbol

# contents.each do |row|
#   name = row[:first_name]
#   zipcode = clean_zipcode(row[:zipcode])
#   puts "#{name} #{zipcode}"
# end 

# -----Iteration 3: Using Google's Civiv Information  -----
require "csv"
require 'google/apis/civicinfo_v2'

civic_info = Google::Apis::CivicinfoV2::CivicInfoService.new
civic_info.key = 'AIzaSyClRzDqDh5MsXwnCWi0kOiiBivP6JsSyBw'


def clean_zipcode(zipcode)
  if zipcode.nil?
    "00000"
  elsif zipcode.length < 5
    zipcode.rjust(5, "0")
  elsif zipcode.length > 5
    zipcode.slice[0..4]
  else 
    zipcode
  end 
end 

contents = CSV.open "event_attendees.csv", headers: true, header_converters: :symbol

contents.each do |row|
  name = row[:first_name]
  zipcode = clean_zipcode(row[:zipcode])
  puts "#{name} #{zipcode}"
end 