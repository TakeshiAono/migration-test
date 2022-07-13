class Task < ApplicationRecord
  validates :title, presence: true
  validates :content, presence: true
  validates :deadline, presence: true

  enum status: {
    not_yet:0,doing:1,done:2
  }
  enum priority:{
    high:0, medium:1, low:2
  }

  def self.search(search)
    search ? where('title LIKE ?',"%#{search}%") : all
  end
end
