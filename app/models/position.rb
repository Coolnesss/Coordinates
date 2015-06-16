class Position < ActiveRecord::Base
  validates :x, presence: true, numericality: true, format: {
    with: /\A[-+]?([1-8]?\d(\.\d+)?|90(\.0+)?)\z/,
    message: "Not a real coordinate"
  }
  validates :y, presence: true, numericality: true, format: {
    with: /\A\s*[-+]?(180(\.0+)?|((1[0-7]\d)|([1-9]?\d))(\.\d+)?)\z/,
    message: "Not a real coordinate"
  }
end
