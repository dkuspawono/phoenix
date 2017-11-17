require 'json'
require 'pry'

@arr_errors = []
@pass = 0
puts "Importing points..."
Dir[File.join(Rails.root, "old_db/points/*.json")].each do |json_file|

  hash = JSON.parse(File.read(json_file))

  status = (hash['needModeration'] == "true" ? "approved" : "pending")

  begin
    unless (Service.find_by(hash['service'])).nil?
      service = Service.find_by(hash['service'])
    else
      service = Service.create(name: hash['service'])
    end
  rescue
    service = Service.new(name: "unknown service")
  end

  begin
    unless (Topic.find_by(hash['topics'])).nil?
      topic = Topic.find_by(hash['topics'])
    else
      topic = Topic.create(title: hash['topics'])
    end
  rescue
    topic = Topic.new(title: "unknown topic")
  end

  imported_point = Point.new(
    user_id: 1, # go make the script look for the user, if no user, make it default
    title: hash['title'],
    source: hash['discussion'],
    service_id: service.id,
    status: status,
    analysis: hash['tldr'] || hash['tosdr']['tldr'] || 'random text',
    rating: hash['tosdr']['score'] || 5,
    topic_id: topic.id, #need to import topics first and match it by string
    )
  # binding.pry
  unless imported_point.valid?
    @arr_errors << imported_point.title
    puts "### #{imported_point.title} not imported"
  else
    @pass =+ 1
    imported_point.save
    puts "#{imported_point.title} imported and saved!"
  end
end
puts "Finishing importing points"
puts "errors: #{@arr_errors.count}"
puts "passed: #{@pass}"
puts "Done!"
