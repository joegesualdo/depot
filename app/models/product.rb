# == Schema Information
#
# Table name: products
#
#  id          :integer          not null, primary key
#  title       :string(255)
#  description :text
#  image_url   :string(255)
#  price       :decimal(, )
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

class Product < ActiveRecord::Base
  attr_accessible :description, :image_url, :price, :title

  before_destroy :ensure_not_referenced_by_any_line_item

  default_scope order: 'title'


  validates :description, :image_url, :title, :presence => true

  validates :price, :numericality => {:greater_than_or_equal_to => 0.01}

  validates :title, :uniqueness => true

  validates :image_url, :format => {
      :with => %r{\.(gif|jpg|png)}i,
      :message => 'Must be a URL for GIF'
  }

  has_many :line_items


  private

  # Ensure there are no line items referencing this product
  def ensure_not_referenced_by_any_line_item
    if line_items.empty?
      return true
    else
      errors.add(:base, 'Line items present')
      return false
    end
  end
end
