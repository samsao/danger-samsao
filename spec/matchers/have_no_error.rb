require 'rspec/expectations'

RSpec::Matchers.define :have_no_error do
  match do |actual|
    actual.status_report[:errors].empty?
  end

  failure_message do |actual|
    message = "expected that #{Danger} would have no error but found '#{actual.status_report[:errors].size}'"
    actual.status_report[:errors].each do |error|
      message += "\n * #{error}"
    end
  end
end
