class Project < ActiveRecord::Base
  include PublicActivity::Model
  attr_accessible :desc, :name
  has_many :discussions
  has_many :tasks
  has_many :project_memberships
  has_many :users, :through => :project_memberships

  validates :name, :presence => true, :length => {:minimum => 3}

  acts_as_paranoid
  acts_as_commentable

  tracked


  # define project.admins, project.members ... methods
  ProjectMembership.role.values.each do |r|
    send(:define_method, r.underscore.pluralize) do
      self.project_memberships.where(:role => r.underscore).map(&:user)
    end
  end


  def project_manager
    #self.project_memberships.where(:project_id => project_id).first.role.text
    pm = nil
    project = self
    self.users.each do |u|
      if u.project_memberships.where(:project_id => project.id).first.role == "project_manager"
        pm = u
      end
    end
    pm
  end


  def urgent
    self.tasks.where(:task_type => "3").order("end")
  end

  def draft
    self.tasks.where(:task_type => "5").order("created_at DESC")
  end

  def my_work user
    self.tasks.where(:assigned_to => user.id).where("task_type != 5").where("task_type != 3")
  end

  def icebox
    self.tasks.where(:place => 0).where("task_type != 5").where("task_type != 3")
  end

  def backlog
    self.tasks.where(:place => 1).where("task_type !=5").where("task_type !=3")
  end

end
