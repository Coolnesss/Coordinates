class Position < ActiveRecord::Base
  #validates :x, format: {
  #  with: /^[-+]?([1-8]?\d(\.\d+)?|90(\.0+)?)/,
  #  message: "Not a real coordinate"
  #}
  #validates :y, format: {
  #  with: /\s*[-+]?(180(\.0+)?|((1[0-7]\d)|([1-9]?\d))(\.\d+)?)$/,
  #  message: "Not a real coordinate"
  #}
end
