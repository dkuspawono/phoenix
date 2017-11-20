require 'json'
require 'pry'

puts "Starting the loop and the import..."
Dir[File.join(Rails.root,"old_db/topics/*.json")].each do |json_file|
  hash = JSON.parse(File.read(json_file))
  imported_topic = Topic.new(
    title: hash['name'],
    subtitle: hash['subtitle'] || 'no text here',
    description: hash['description'] || 'no text here')
    # binding.pry
    unless imported_topic.valid?
      puts "### #{imported_topic.title} not imported ! ###"
    else
      puts "Imported and saved: #{imported_topic.title}"
      imported_topic['title'] = imported_topic['title'].downcase
      imported_topic.save
    end
    puts "Exiting loop"
  end
  puts "Finishing importing topics!"
