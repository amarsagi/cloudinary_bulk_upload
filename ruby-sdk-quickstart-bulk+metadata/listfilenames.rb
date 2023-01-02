require 'csv'


# Dir.each child shown below will give a filename list  inside the csv
# Dir.each_child('full_path') do |filename|
#   files << filename
# end
# For the purpose of the excercise we will use full path

files = []
Dir.glob('/Users/sagiamar/Documents/Cloudinary/training/bulkupload/ruby-sdk-quickstart-bulk+metadata/assets/*') do |filename|
    files << filename
end

puts files
new_values = {'blackberry'=>'fruit','cookies'=>'desert','face'=>'smile', 'faces'=>'smiles', 'grapes'=>'fruit', 'kiwi'=>'fruit', 'lake'=>'water', 'logo'=>'cloudinary', 'oranges'=>'fruit', 'pineapple'=>'fruit', 'shirt'=>'clothes'}

headers = ["Public_ID","Description"]
CSV.open("test.csv", "w") do |csv|
  csv << headers
  files.each do |filename|
    temp_name = filename.split("/")[-1].sub(/\.[^.]+\z/, '')
    csv << [filename, new_values[temp_name]]
  end
end












