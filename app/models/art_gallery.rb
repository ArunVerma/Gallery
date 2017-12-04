class ArtGallery
  include ActiveModel::Model

  attr_accessor :file

  validates :file, presence: true
  validate :attchment_type

  # validates file type
  def attchment_type
    if @file.present? && @content_type != 'text/plain'
      errors.add(:file, "should only be a 'text' file")
    end
  end

  def initialize(txt_file, content_type)
    if txt_file.present?
      @file = File.open(txt_file, 'r')
      @content_type = content_type
      @record = {}
    end
  end

  def collect_data
    #Formating data in the following hash structure
    #{'room'  => { 'visitor' => { 'in' => 'time', 'out' => 'time'}
    #droping first line as it is number of lines in the log file
    file.drop(1).each do|line|
      visitor_id, room_number, action, timestamp = line.strip.split(' ')
      next if visitor_id.to_i > 1023 || room_number.to_i > 99
      entry_time =  action == "I" ? {'In' => timestamp.to_i} : {}
      exit_time =  action == "O" ? {'Out' => timestamp.to_i} : {}
      entry_exit_time = {}.merge(entry_time).merge(exit_time)
      if @record.has_key?(room_number) && @record[room_number].has_key?(visitor_id)
        @record[room_number][visitor_id].merge!(entry_exit_time)
      elsif @record.has_key?(room_number) && !@record[room_number].has_key?(visitor_id)
        @record[room_number].merge!({ visitor_id => entry_exit_time})
      else
        @record[room_number] = { visitor_id => entry_exit_time}
      end
    end
    parse_results
  end

  def parse_results
    data = @record.sort.reduce([]) do |result, (key, value)|
      no_of_visitors = value.keys.length
      #calculating total time spend bye each visitor(sum)
      total_time_spend = value.values.reduce(0) { |total, rec| total += (rec["Out"] - rec["In"]) }
      average_time = total_time_spend/no_of_visitors
      result << [key, average_time, no_of_visitors]
    end
  end
end
