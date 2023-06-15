class WalkingRoute < ApplicationRecord
  validates :name, :comment, :distance, :duration, :start_address, :end_address, :encorded_path,
    presence: true
end
