# frozen_string_literal: true

require 'spec_helper'

module BrregGrunndata
  describe Configuration do
    subject do
      described_class.new userid: 'user', password: 'password'
    end

    it 'contains userid' do
      expect(subject.userid).to eq 'user'
    end

    it 'contains password' do
      expect(subject.password).to eq 'password'
    end

    it 'contains wsdl' do
      expect(subject.wsdl).to eq described_class::WSDL
    end
  end
end
