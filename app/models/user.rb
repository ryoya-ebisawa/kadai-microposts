class User < ApplicationRecord
  before_save { self.email.downcase! }
  validates :name, presence: true, length: { maximum: 50 }
  validates :email, presence: true, length: { maximum: 255 },
                    format: { with: /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i },
                    uniqueness: { case_sensitive: false }
  has_secure_password

  has_many :microposts
  
  #自分がフォローしているユーザたちを取得
  has_many :relationships
  #'through: :relationships' で 'has_many :relationships' の結果を中間テーブルとして指定
  #中間テーブルの参照するカラムを 'source: :follow'で指定している
  has_many :followings, through: :relationships, source: :follow
  
  #class_name: 'Relationshipで参照するクラスを指定している
  has_many :reverses_of_relationship, class_name: 'Relationship', foreign_key: 'follow_id'
  has_many :followers, through: :reverses_of_relationship, source: :user


  #自分自身か検証
  #create = build + save
  def follow(other_user)
    unless self == other_user
      self.relationships.find_or_create_by(follow_id: other_user.id)
    end
  end

  #アンフォロー
  #relationship が存在すれば destroy
  def unfollow(other_user)
    relationship = self.relationships.find_by(follow_id: other_user.id)
    relationship.destroy if relationship
  end

  #other_userをフォローしているか
  def following?(other_user)
    self.followings.include?(other_user)
  end
  
end