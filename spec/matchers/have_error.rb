require 'rspec/expectations'

RSpec::Matchers.define :have_error do |expected|
  match do |actual|
    actual.status_report[:errors].any? do |error|
      expected.is_a?(Regexp) ? error =~ matcher : error.start_with?(expected)
    end
  end

  failure_message do |actual|
    message = "expected that #{Danger} would have error '#{expected}'"

    errors = actual.status_report[:errors]
    if errors.empty?
      message += ' but there is none'
      return message
    end

    actual.status_report[:errors].each do |error|
      message += "\n * #{error}"
    end

    message
  end
end
