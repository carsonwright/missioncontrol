class Pivotal
  ACCOUNTS = YAML.load(File.open("#{Rails.root}/config/accounts.yml", "r"))
  PROJECTS = YAML.load(File.open("#{Rails.root}/config/pivotal_projects.yml", "r"))

  # connect
  # connects to the Pivotal Tracker account
  # @author Jason Truluck
  def self.connect
    PivotalTracker::Client.use_ssl = true
    PivotalTracker::Client.token(ACCOUNTS['pivotal_tracker']['email'],
                                 ACCOUNTS['pivotal_tracker']['password'])
  end
  # activity_feed
  # returns the activity feed for all projects
  # @author Jason Truluck
  def self.activity_feed
    connect
    PivotalTracker::Activity.all
  end

  # activity_feed_for
  # returns the activity feed to the defined project
  # @param [Integer] project_id the project id for the project being queried
  # @author Jason Truluck
  def self.activity_feed_for(project_id)
    connect
    project = PivotalTracker::Project.find(project_id)
    project.activities.all
  end
end
