require_relative '../spec_helper'

describe Mumukit::Platform::Locale do
  it { expect(Mumukit::Platform::Locale.supported).to eq %w(en es es-CL pt) }

  it { expect(Mumukit::Platform::Locale.get_spec_for :es, :name ).to eq 'Español' }
  it { expect(Mumukit::Platform::Locale.get_spec_for :'es-CL', :name ).to eq 'Español chileno' }
  it { expect(Mumukit::Platform::Locale.get_spec_for :pt, :auth0_code ).to eq 'pt-br' }
  it { expect(Mumukit::Platform::Locale.get_spec_for :foo, :auth0_code ).to be nil }
  it { expect(Mumukit::Platform::Locale.get_spec_for :pt, :bar ).to be nil }
end
