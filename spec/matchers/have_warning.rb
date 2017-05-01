require 'rspec/expectations'

RSpec::Matchers.define :have_warning do |expected|
  match do |actual|
    actual.status_report[:warnings].any? do |warning|
      expected.is_a?(Regexp) ? warning =~ matcher : warning.start_with?(expected)
    end
  end

  failure_message do |actual|
    message = "expected that #{Danger} would have warning '#{expected}'"

    warnings = actual.status_report[:warnings]
    if warnings.empty?
      message += ' but there is none'
      return message
    end

    actual.status_report[:warnings].each do |warning|
      message += "\n * #{warning}"
    end

    message
  end
end
