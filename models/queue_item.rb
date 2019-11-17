require 'mongoid'

class QueueItem
  include Mongoid::Document

  field :title, type: String
  field :file_path, type: String
  has_one :queue_item, :foreign_key => 'previous', validate: false
  has_one :queue_item, :foreign_key => 'next', validate: false

  validates :title, presence: true
  validates :file_path, presence: true, uniqueness: true
end
