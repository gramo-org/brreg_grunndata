# frozen_string_literal: true

require 'spec_helper'

module BrregGrunndata
  class Client
    describe SokEnhetQueryToXml do
      subject do
        described_class.new 'STATOIL',
                            first: 10
      end

      describe '#cdata' do
        it 'returns expected XML string with cdata' do
          expected = <<~XML
            <![CDATA[<BrAixXmlRequest RequestName="BrErfrSok">
            <BrErfrSok>
            <BrSokeStreng>STATOIL</BrSokeStreng>
            <MaxTreffReturneres>10</MaxTreffReturneres>
            <ReturnerIngenHvisMax>true</ReturnerIngenHvisMax>
            <RequestingIPAddr>010.001.052.011</RequestingIPAddr>
            <RequestingTjeneste>SOAP</RequestingTjeneste>
            <MedUnderenheter>true</MedUnderenheter>
            </BrErfrSok>
            </BrAixXmlRequest>
            ]]>
          XML

          expect(subject.cdata).to eq expected.delete "\n"
        end
      end
    end
  end
end
