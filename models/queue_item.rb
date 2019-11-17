require 'mongoid'
require 'mongoid-grid_fs'

class QueueItem
  include Mongoid::Document

  field :title, type: String
  field :file_id, type: String
  has_one :queue_item, :foreign_key => 'previous', validate: false
  has_one :queue_item, :foreign_key => 'next', validate: false

  validates :title, presence: true

  def set_file_id(file_path)
    self.file_id = Mongoid::GridFS.put(File.open(file_path)).id
    self.save
  end

  def get_file
    Mongoid::GridFS.get(file_id)
  end
end
