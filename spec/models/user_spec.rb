require 'rails_helper'

RSpec.describe User, :type => :model do
  it "is valid phone number" do
    should allow_value('+380501234567').for(:phone)
    should allow_value('+380-67-111-1111').for(:phone)
    should_not allow_value('+380-abcde').for(:phone)
  end
end

end
