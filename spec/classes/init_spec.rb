require 'spec_helper'
describe 'backup' do
  context 'with default values for all parameters' do
    it { should contain_class('backup') }
  end
end
