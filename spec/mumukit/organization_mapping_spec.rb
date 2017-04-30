require_relative '../spec_helper'

describe Mumukit::Platform::OrganizationMapping do
  it { expect(Mumukit::Platform::OrganizationMapping.from_env).to eq Mumukit::Platform::OrganizationMapping::Subdomain }
end
