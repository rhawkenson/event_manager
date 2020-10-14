require "csv"

puts "EventManager Initialized!"

#Use the File.read class and method to access data 
contents = File.read "event_attendees.csv"
#puts contents 

File.exist? "event_attendees.csv"


lines = File.readlines "event_attendees.csv"
lines.each do |line|
  next if line == " ,RegDate,first_Name,last_Name,Email_Address,HomePhone,Street,City,State,Zipcode\n"
  columns = line.split(",")
  name = columns[2]
  puts name
end 

#Use the built-in Ruby CSV Parser 
  #See require statement line 1


  # contents = CSV.open "event_attendees.csv"
  # contents.each do |row|
  #   name = row[2]
  #   puts name
  # end 