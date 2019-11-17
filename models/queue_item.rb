require 'mongoid'
require 'mongoid-grid_fs'

class QueueItem
  include Mongoid::Document

  field :title, type: String

  validates :title, presence: true
end
