require 'json'
require 'pry'
require 'uri'

puts "Starting the loop and the import..."
@arr_errors = []
Dir[File.join(Rails.root,"old_db/services/*.json")].each do |json_file|
  hash = JSON.parse(File.read(json_file))
  binding.pry
  begin
    unless (hash['fulltos']['terms']['url']).nil?
      url = hash['fulltos']['terms']['url']
    else
      unless (hash['fulltos']['url']).nil?
        url = hash['fulltos']['url']
      else
        unless (hash['url']).nil?
          url = hash['url']
        else
          url = "no url"
        end
      end
    end
  rescue
    url = "no url"
  end

  imported_service = Service.find_or_add(
    hash['name'],
    url)
  unless imported_service.url.scan(URI.regexp)
    puts "### #{imported_service.name} not imported ! ###"
    @arr_errors << imported_service.name
  else
    puts "Imported and saved: #{imported_service.name}"
  end
  puts "Exiting loop"
end
puts "Finishing importing topics!"
puts "Returning errors: #{@arr_errors}"
