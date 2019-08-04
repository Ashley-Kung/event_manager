require 'csv'
require 'google/apis/civicinfo_v2'

def clean_zipcode(zipcode)
#  if zipcode.nil?
#    zipcode = "00000"  
#  elsif zipcode.length < 5
#    zipcode = zipcode.rjust 5, "0"
#  elsif zipcode.length > 5
#    zipcode = zipcode[1..4]  
#  else
#    zipcode
#  end
  zipcode.to_s.rjust(5, "0")[0..4]
end

def legislators_by_zipcode(zip)
  civic_info = Google::Apis::CivicinfoV2::CivicInfoService.new
  civic_info.key = 'AIzaSyClRzDqDh5MsXwnCWi0kOiiBivP6JsSyBw'

  begin
    legislators = civic_info.representative_info_by_address(
      address: zip,
      levels: 'country',
      roles: ['legislatorUpperBody', 'legislatorLowerBody']
    )
    legislators = legislators.officials
    #legislator_names = legislators.map do |legislator|
    #  legislator.name
    #end
    legislator_names = legislators.map(&:name).join(', ')
  rescue
    "You can find your representatives by visiting www.commoncause.org/take-action/find-elected-officials"
  end
end

puts "EventManager Initialized!"

#contents = File.read "event_attendees.csv"
#puts contents

#lines = File.readlines "event_attendees.csv"
#lines.each_with_index do |line, index|
#  next if index == 0
#  columns = line.split(',')
#  name = columns[2]
#  puts name
#end

contents = CSV.open "event_attendees.csv", headers: true, header_converters: :symbol
contents.each do |row|
  name = row[:first_name]
#  zipcode = row[:zipcode]
  zipcode = clean_zipcode(row[:zipcode])
  legislators = legislators_by_zipcode(zipcode)
  puts "#{name} #{zipcode} #{legislators}"
end