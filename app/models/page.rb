class Page < ApplicationRecord
  validates :title, presence: true
  validates :content, presence: true
  validates :slug, presence: true, uniqueness: true

  def self.ransackable_associations(auth_object = nil)
    %w[author categories tags]
  end

  def self.ransackable_attributes(auth_object = nil)
    %w[title content created_at slug]
  end
end
