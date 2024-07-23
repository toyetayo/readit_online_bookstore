class Page < ApplicationRecord
  validates :title, presence: true
  validates :content, presence: true
  validates :slug, presence: true, uniqueness: true
  def self.ransackable_attributes(auth_object = nil)
    %w[content created_at id title updated_at]
  end
end
