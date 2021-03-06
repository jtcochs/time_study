class FavoriteActivity < ActiveRecord::Base
  attr_accessible :activity_category_id

  belongs_to :user
  belongs_to :county
  belongs_to :job_classification
  has_many :activity_categories

  validates_uniqueness_of :activity_category_id, scope: :user_id, if: lambda { !user_id.nil? }
  validates_uniqueness_of :activity_category_id, scope: [:county_id, :job_classification_id], if: lambda { !county_id.nil? }

end