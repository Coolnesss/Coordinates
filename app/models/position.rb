class Position < ActiveRecord::Base

  has_many :reports, dependent: :destroy
  has_many :pictures, dependent: :destroy
  reverse_geocoded_by :lat, :lon do |obj,geo|
    geo.first
  end


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
          updates: position.updates,
          status: position.find_status,
          detailed_status: position.find_detailed_status,
          status_notes: position.find_status_notes,
          issue_id: position.issue_id
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

  def one_picture_url
    self.pictures.first.image.url unless self.pictures.empty?
  end

  def self.service_codes
    codes = Hash.new
    codes[171] = [:huonovayla, :korkeareuna, :kunnossapito, :eiauraus,
      :lumikasa, :huonoauraus, :polanne, :liukas, :sepeli, :talvikpmuu]
    codes[198] = [:opastekp]
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

  def find_status
    issue = find_issue_report
    issue["status"] if issue
  end

  def find_detailed_status
    issue = find_issue_report
    issue["extended_attributes"]["detailed_status"] if issue and issue["extended_attributes"]
  end

  def find_status_notes
    issue = find_issue_report
    issue["status_notes"] if issue
  end

  def find_issue_report
    return nil if not self.issue_id
    resp = IssueReporter.all
    resp.find{|x| x["service_request_id"] == self.issue_id}
  end

  def send_to_api
    if not self.issue_id.present? and self.in_helsinki? then
      self.send_to_api!
    end
  end

  def send_to_api!
    SendReportJob.perform_later self.id
  end

  def in_helsinki?
    geocode = self.reverse_geocode
    geocode.present? and (geocode.city == "Helsingfors" or geocode.city == "Helsinki")
  end
end
