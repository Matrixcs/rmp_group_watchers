module Rmpgw
  module IssuePatch
    def self.included(base)
      base.send :include, InstanceMethods

      base.class_eval do
        alias_method_chain :addable_watcher_users, :rmpgw
      end
    end

    module InstanceMethods
      def addable_watcher_users_with_rmpgw
        users = addable_watcher_users_without_rmpgw
        Group.sorted.to_a + users
      end
    end
  end
end