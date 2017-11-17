require 'json'
require 'pry'

puts "Starting the loop and the import..."
@arr_errors = []
Dir[File.join(Rails.root,"old_db/services/*.json")].each do |json_file|
  hash = JSON.parse(File.read(json_file))
  imported_service = Service.find_or_add(
    hash['name'],
    hash['fulltos']['terms']['url'])
  unless imported_service.valid?
    puts "### #{imported_service.name} not imported ! ###"
    @arr_errors << imported_service.name
  else
    puts "Imported and saved: #{imported_service.name}"
  end
  puts "Exiting loop"
end
puts "Finishing importing topics!"
puts @arr_errors
