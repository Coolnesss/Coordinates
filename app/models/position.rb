class Position < ActiveRecord::Base

  has_many :reports, dependent: :destroy
  has_many :pictures, :dependent => :destroy

  enum category: {
    #Migraatio mis muutat integerin stringiks tän categoryn arvoilla
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


  accepts_nested_attributes_for :pictures#, :reject_if => lambda { |t| t['picture'].nil? }


  def date_format
    date = self.created_at
    date.day.to_s + "." + date.month.to_s + "." + date.year.to_s
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

end
