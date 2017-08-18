require 'rspec/expectations'

RSpec::Matchers.define :have_message do |expected|
  match do |actual|
    actual.status_report[:messages].any? do |message|
      expected.is_a?(Regexp) ? message =~ matcher : message.start_with?(expected)
    end
  end

  failure_message do |actual|
    result = "expected that #{Danger} would have warning '#{expected}'"

    messages = actual.status_report[:messages]
    if messages.empty?
      result += ' but there is none'
      return result
    end

    actual.status_report[:messages].each do |message|
      result += "\n * #{message}"
    end

    result
  end
end
