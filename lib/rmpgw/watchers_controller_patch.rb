# RMP Group Watchers plugin
# Copyright (C) 2015 Kovalevsky Vasil (RMPlus company)
# Developed by Kovalevsky Vasil by order of "vira realtime" http://rlt.ru/

module Rmpgw
  module WatchersControllerPatch
    def self.included(base)
      base.send :include, InstanceMethods

      base.class_eval do
        alias_method_chain :autocomplete_for_user, :rmpgw
        alias_method_chain :append, :rmpgw
        alias_method_chain :create, :rmpgw
      end
    end

    module InstanceMethods
      def autocomplete_for_user_with_rmpgw
        if params[:object_type].blank? || params[:object_type] == 'issue'
          @users = Group.order(:lastname).where(type: 'Group').like(params[:q]).limit(100).to_a + User.active.sorted.like(params[:q]).limit(100).to_a
          if @watched
            @users -= @watched.watcher_users
          end
          render layout: false
        else
          autocomplete_for_user_without_rmpgw
        end
      end

      def append_with_rmpgw
        if params[:watcher].is_a?(Hash)
          user_ids = params[:watcher][:user_ids] || [params[:watcher][:user_id]] || []
          @users = User.joins("LEFT JOIN groups_users on groups_users.user_id = #{User.table_name}.id").active.where("groups_users.group_id in (:user_ids) or #{User.table_name}.id in (:user_ids)", user_ids: user_ids + [0]).uniq.sorted
        end
      end

      def create_with_rmpgw
        if @watched.is_a?(Issue)
          if params[:watcher].is_a?(Hash)
            user_ids = (params[:watcher][:user_ids] || params[:watcher][:user_id])
          else
            user_ids = params[:user_id]
          end
          params[:watcher] = {}
          params[:watcher][:user_id] = User.joins("LEFT JOIN groups_users on groups_users.user_id = #{User.table_name}.id").active.where("groups_users.group_id in (:user_ids) or #{User.table_name}.id in (:user_ids)", user_ids: user_ids + [0]).uniq.sorted.map(&:id)
        end

        create_without_rmpgw
      end
    end
  end
end