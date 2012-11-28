class Project < ActiveRecord::Base


  attr_accessible :desc, :name

  #default_scope order('created_at DESC')

  has_many :discussions
  has_many :project_memberships
  has_many :users, :through => :project_memberships

  validates :name, :presence => true, :length => { :minimum => 5 }

  acts_as_commentable

  # define project.admins, project.members ... methods
  ProjectMembership.role.values.each do |r|
    send(:define_method, r.underscore.pluralize) do
      self.project_memberships.where(:role => r.underscore).map(&:user)
    end
  end


end
