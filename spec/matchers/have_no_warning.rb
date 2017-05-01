require 'rspec/expectations'

RSpec::Matchers.define :have_no_warning do
  match do |actual|
    actual.status_report[:warnings].empty?
  end

  failure_message do |actual|
    message = "expected that #{Danger} would have no warning but found '#{actual.status_report[:warnings].size}'"
    actual.status_report[:warnings].each do |warning|
      message += "\n * #{warning}"
    end
  end
end
