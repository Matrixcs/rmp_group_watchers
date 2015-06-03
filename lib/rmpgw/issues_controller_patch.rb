# RMP Group Watchers plugin
# Copyright (C) 2015 Kovalevsky Vasil (RMPlus company)
# Developed by Kovalevsky Vasil by order of "vira realtime" http://rlt.ru/

module Rmpgw
  module IssuesControllerPatch
    def self.included(base)
      base.send :include, InstanceMethods

      base.class_eval do
        alias_method_chain :build_new_issue_from_params, :rmpgw
      end
    end

    module InstanceMethods
      def build_new_issue_from_params_with_rmpgw
        build_new_issue_from_params_without_rmpgw
        @available_watchers = Group.sorted.to_a + (@available_watchers || [])
      end
    end
  end
end