require 'spec_helper'

module BrregGrunndata
  describe Configuration do
    subject do
      described_class.new username: 'user', password: 'password'
    end

    it 'contains username' do
      expect(subject.username).to eq 'user'
    end

    it 'contains password' do
      expect(subject.password).to eq 'password'
    end

    it 'contains wsdl' do
      expect(subject.wsdl).to eq described_class::WSDL
    end
  end
end
