require 'rspec/expectations'

RSpec::Matchers.define :have_no_error do
  match do |actual|
    actual.status_report[:errors].empty?
  end
end
