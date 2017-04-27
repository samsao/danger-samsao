require 'samsao/config'

module Danger
  # Samsao's Danger plugin.
  #
  # @example See README.md
  #
  # @see samsao/danger-samsao
  # @tags internal, private, enterprise
  #
  class DangerSamsao < Plugin
    # Enable to configure the plugin configuration object.
    #
    # @return [Array<String>] (if no block given)
    def config(&block)
      @samsao_config = Danger::SamsaoConfig.new if @samsao_config.nil?
      return @samsao_config unless block_given?

      @samsao_config.instance_eval(&block)
    end

    # Fails when git branching model is not respected for PR branch name.
    #
    # @return [void]
    def fail_when_wrong_branching_model
      message = 'Your branch should be prefixed with feature/, fix/ or release/!'

      fail message unless respects_branching_model(github.branch_for_head)
    end

    private

    def respects_branching_model(branch)
      parts = branch.split('/')

      ['fix', 'feature', 'release'].include?(parts[0])
    end
  end
end
