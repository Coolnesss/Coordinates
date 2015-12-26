class Position < ActiveRecord::Base

  has_many :reports, dependent: :destroy
  has_many :pictures, dependent: :destroy

  enum category: {
    huonovayla: "Kunnossapito, Huonokuntoinen väylä",
    korkeareuna: "Kunnossapito, Korkea reunakivi",
    opastekp: "Kunnossapito, Opaste tai liikennemerkki",
    kunnossapito: "Kunnossapito, Muu",
    vaylajatkuvuus: "Suunnittelu, Väylän jatkuvuus",
    selkeys: "Suunnittelu, Reitin selkeys",
    suunnittelu: "Suunnittelu, Muu",
    epaselvaopaste: "Poikkeusjärjestely, Epäselvät opasteet",
    huonojarj: "Poikkeusjärjestely, Huono järjestely",
    poikkeusmuu: "Poikkeusjärjestely, Muu",
    eiauraus: "Talvikunnossapito, Väylää ei ole aurattu",
    lumikasa: "Talvikunnossapito, Lumikasa väylällä",
    huonoauraus: "Talvikunnossapito, Aurattu huonosti",
    polanne: "Talvikunnossapito, Väylällä polanteita",
    liukas: "Talvikunnossapito, Liukas väylä",
    sepeli: "Talvikunnossapito, Liikaa sepeliä",
    talvikpmuu: "Talvikunnossapito, Muu"
  }

  validates :email, email: true, allow_nil: true
  validates :name, :description, :lon, :lat, presence: true
  validates :name, length: { maximum: 27 }
  validates :description, length: { minimum: 15, maximum: 270 }
  validates_numericality_of :lon
  validates_numericality_of :lat
  validates :category, presence: true


  accepts_nested_attributes_for :pictures#, :reject_if => lambda { |t| t['picture'].nil? }


  def date_format
    date = self.created_at
    date.day.to_s + "." + date.month.to_s + "." + date.year.to_s
  end

  def create_images(images)
    images.each { |image|
      self.pictures.create(image: image)
    }
  end

  def self.geopoints
    points = Array.new

    Position.all.order(:name).each do |position|
      points << {
        type: 'Feature',
        geometry: {
          type: 'Point',
          coordinates: [position.lon, position.lat]
        },
        properties: {
          id: position.id,
          name: position.name,
          description: position.description,
          votes: position.votes,
          date: position.date_format,
          images: position.picture_urls,
          category: position[:category],
          updates: position.updates
        }
      }
    end
    points
  end

  def picture_urls
    if self.pictures.empty? then
      return nil
    end
    urls = Array.new
    self.pictures.each do |p|
      urls << p.image.url
    end
    urls
  end

  def self.service_codes
    codes = Hash.new

    codes[171] = Array.new
    codes[171] << :huonovayla
    codes[171] << :korkeareuna
    codes[171] << :kunnossapito
    codes[171] << :eiauraus
    codes[171] << :lumikasa
    codes[171] << :huonoauraus
    codes[171] << :polanne
    codes[171] << :liukas
    codes[171] << :sepeli
    codes[171] << :talvikpmuu

    codes[198] = Array.new
    codes[198] << :opastekp

    codes[180] = Array.new
    Position.categories.each do |symbol, description|
      symbol = symbol.to_sym
      codes[180] << symbol unless (codes[171].include? symbol or codes[198].include? symbol)
    end
    codes
  end

  def deduce_service_code()
    Position.service_codes.each do |code, cats|
      return code unless not cats.include? self.category.to_sym
    end
  end
end
