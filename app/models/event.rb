class Event < ActiveRecord::Base
  belongs_to :organizer, class_name: 'User'
  has_many :taggings
  has_many :tags, through: :taggings
  has_many :attendances
  has_many :users, through: :attendances

  extend FriendlyId
  friendly_id :title, use: :slugged

  def all_tags=(names)
    self.tags = names.split(',').map do |t|
      Tag.where(name: t.downcase.strip).first_or_create!
    end
  end

  def all_tags
    tags.map(&:name).join(', ')
  end

  def self.tagged_with(name)
    Tag.find_by!(name: name).events
  end

  def self.tag_counts
    Tag.all.map { |t| Tagging.where(tag_id: t.id).count.to_s + " x #{t.name}" }.sort.reverse
  end
# Not sure about the last method
  def self.event_owner(organizer_id)
    User.find_by(id: organizer_id)
  end
end
