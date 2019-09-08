require 'rails_helper'

#Test suite for user model
RSpec.describe User, type: :model do


  #Association test
  #ensure User model has a 1:m relationship
  it { should have_many(:todos) }

  #Validation tests
  #ensure name, email and pw digest are present before save
  it { should validate_presence_of(:name) }
  it { should validate_presence_of(:email) }
  it { should validate_presence_of(:password_digest) } 
end
