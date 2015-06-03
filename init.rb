# RMP Group Watchers plugin
# Copyright (C) 2015 Kovalevsky Vasil (RMPlus company)
# Developed by Kovalevsky Vasil by order of "vira realtime" http://rlt.ru/

Redmine::Plugin.register :rmp_group_watchers do
  name 'RMP Group Watchers plugin'
  author 'Kovalevsky Vasil'
  description 'This is a plugin for adding users from group to issue watchers. Developed by order of "vira realtime"'
  version '1.0.0'
  url 'http://rlt.ru/'
  author_url 'http://rmplus.pro'

  # requires_redmine version: '2.3.0'..'2.5.0'
end

Rails.application.config.to_prepare do
  Issue.send(:include, Rmpgw::IssuePatch)
  IssuesController.send(:include, Rmpgw::IssuesControllerPatch)
  WatchersController.send(:include, Rmpgw::WatchersControllerPatch)
end