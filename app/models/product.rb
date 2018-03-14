class Product < ApplicationRecord

  validates :category_id, presence: { message: "分类不能为空" }
  validates :title, presence: { message: "名称不能为空" }
  validates :status, inclusion: { in: %w[on off], 
    message: "商品状态必须为on | off" }
  validates :amount, numericality: { only_integer: true,
    message: "库存必须为整数" },
    if: proc { |product| !product.amount.blank? }
  validates :amount, presence: { message: "库存不能为空" }
  validates :msrp, presence: { message: "MSRP不能为空" }
  validates :msrp, numericality: { message: "MSRP必须大于0" },
    unless: proc { |product| product.msrp.to_i < 0 }
  validates :price, numericality: { message: "价格必须大于0" },
    unless: proc { |product| product.price.to_i < 0 }
  validates :price, presence: { message: "价格不能为空" }
  validates :description, presence: { message: "描述不能为空" }

  belongs_to :category
  has_many :product_images, -> { order(weight: 'desc') }, dependent: :destroy
  has_one :main_product_image, -> { order(weight: 'desc') }, class_name: :ProductImage

  before_create :set_default_attrs

  scope :onshelf, -> { where(status: Status::On) }

  module Status
    On = 'on'
    Off = 'off'
  end

  scope :onshelf, -> { where(status: Status::On) }

  private
  def set_default_attrs
    self.uuid = RandomCode.generate_product_uuid
  end
end