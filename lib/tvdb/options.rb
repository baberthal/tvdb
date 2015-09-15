require 'thor/core_ext/hash_with_indifferent_access'

module TVDB
  class Options < Thor::CoreExt::HashWithIndifferentAccess
    def initialize(opts = {}, default_opts = {})
      super(default_opts.merge(opts || {}))
    end
  end
end
