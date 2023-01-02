require 'cloudinary'
require 'csv'


# Configuration check
# Account Credentials for destination account
if Cloudinary.config.api_key.blank?
    require './config'
  end
  
puts 'My cloud name is:' + Cloudinary.config.cloud_name

files_to_upload = []
descriptions_to_upload = {}


# Get the file list from CSV file.
csv_file = CSV.open('test.csv')
CSV.foreach("test.csv").with_index do |row, i|
  next if i==0 
	files_to_upload << row[0] # first column has the full path name of every file that is looking to be uploaded.
  descriptions_to_upload[row[0]] = row[1]
end
puts files_to_upload.size.to_s + " resources total";
puts files_to_upload if files_to_upload.size < 100 
puts "Start time: "+ Time.new.inspect
sleep 5; # Leave the output above on the screen for a while before proceeding further

# Process uploads in parallel
# Divide into a number of threads to speed up bulk upload process, maximum of 10 threads
transferred_resources = []
threads = []
number_of_threads = 5

chunk_size = files_to_upload.size/number_of_threads
chunks = files_to_upload.each_slice(chunk_size).to_a;0

puts chunk_size
puts chunks.size
puts chunks[0]

chunks.each do |res| #res is a chunk of three or however way the assets were divided
  threads << Thread.new {
    res.each_with_index do |resource,i|
 

        # Decide how to name the new file - in this example, last part of the file path, excluding extension
				new_public_id = resource.split("/")[-1].sub(/\.[^.]+\z/, '') 
        
        puts new_public_id

        puts "#{i}/#{res.length} #{resource} - "+ Time.new.inspect

        result = Cloudinary::Uploader.upload(
                  resource,
                  :public_id => new_public_id,
                  :folder => 'bulkupload',
                  :type => 'upload', 
                  :overwrite => false,
                  :context => {alt: descriptions_to_upload[resource]},
                  :tags => ["migrated"],
                  return_error: true);0

        puts "#{i}/#{res.length} #{resource} - " + Time.new.inspect
        transferred_resources.push(result);0

    end
  }
end;0
threads.each { |thr| thr.join } #This returns your threads back

# Displays any error messages
transferred_resources.select{|a| a['error']}
puts "End time: "+ Time.new.inspect
