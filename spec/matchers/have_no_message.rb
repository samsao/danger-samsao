require 'rspec/expectations'

RSpec::Matchers.define :have_no_message do
  match do |actual|
    actual.status_report[:messages].empty?
  end

  failure_message do |actual|
    result = "expected that #{Danger} would have no message but found '#{actual.status_report[:messages].size}'"
    actual.status_report[:messages].each do |message|
      result += "\n * #{message}"
    end
  end
end
