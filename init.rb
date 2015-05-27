Redmine::Plugin.register :rmp_group_watchers do
  name 'RMP Group Watchers plugin'
  author 'Kovalevsky Vasil'
  description 'This is a plugin for adding users from group to issue watchers'
  version '1.0.0'
  url 'http://rmplus.pro/'
  author_url 'http://rmplus.pro'
end

Rails.application.config.to_prepare do
  Issue.send(:include, Rmpgw::IssuePatch)
  IssuesController.send(:include, Rmpgw::IssuesControllerPatch)
  WatchersController.send(:include, Rmpgw::WatchersControllerPatch)
end