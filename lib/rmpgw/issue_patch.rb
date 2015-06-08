# RMP Group Watchers plugin
# Copyright (C) 2015 Kovalevsky Vasil (RMPlus company)
# Developed by Kovalevsky Vasil by order of "vira realtime" http://rlt.ru/

module Rmpgw
  module IssuePatch
    def self.included(base)
      base.send :include, InstanceMethods

      base.class_eval do
        alias_method_chain :addable_watcher_users, :rmpgw
        alias_method_chain :watcher_user_ids=, :rmpgw
      end
    end

    module InstanceMethods
      def addable_watcher_users_with_rmpgw
        users = addable_watcher_users_without_rmpgw
        Group.order(:lastname).where(type: 'Group').limit(100).to_a + users
      end

      def watcher_user_ids_with_rmpgw=(user_ids)
        if user_ids.is_a?(Array)
          user_ids = user_ids.uniq
          user_ids = User.joins("LEFT JOIN groups_users on groups_users.user_id = #{User.table_name}.id").active.where("groups_users.group_id in (:user_ids) or #{User.table_name}.id in (:user_ids)", user_ids: user_ids + [0]).uniq.sorted.map(&:id)
        end

        send :watcher_user_ids_without_rmpgw=, user_ids
      end
    end
  end
end