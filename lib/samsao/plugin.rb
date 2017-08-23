require 'samsao/actions'
require 'samsao/config'
require 'samsao/helpers'
require 'samsao/regexp'

module Danger
  # Samsao's Danger plugin.
  #
  # @example See README.md
  #
  # @see samsao/danger-samsao
  # @tags internal, private, enterprise
  #
  class DangerSamsao < Plugin
    include Samsao::Actions
    include Samsao::Helpers

    # Enable to configure the plugin configuration object.
    #
    # @return [Array<String>] (if no block given)
    #
    def config(&block)
      @config = Danger::SamsaoConfig.new if @config.nil?
      return @config unless block_given?

      @config.instance_eval(&block)
    end
  end
end
