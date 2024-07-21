class Page < ApplicationRecord
  def self.ransackable_attributes(auth_object = nil)
    %w[content created_at id id_value title updated_at]
  end
end
