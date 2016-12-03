# frozen_string_literal: true

$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'brreg_grunndata'

module FixtureHelper
  def read_fixture(name)
    path = "#{__dir__}/fixtures/#{name}.xml"
    File.read path
  rescue Errno::ENOENT
    raise "No fixture file found at: #{path}"
  end

  # rubocop:disable all
  def fixture_hent_basisdata_mini_hash(orgnr: '992090936')
    case orgnr
    when '992090936'
      {
        :organisasjonsnummer=>'992090936',
        :navn=>{:navn1=>'PETER SKEIDE CONSULTING', :@registrerings_dato=>'2007-12-19'},
        :forretnings_adresse=>{:adresse1=>'Bård Skolemesters vei 6', :postnr=>'0590',
        :poststed=>'OSLO', :kommunenummer=>'0301', :kommune=>'OSLO', :landkode=>'NOR',
        :land=>'Norge', :@registrerings_dato=>'2008-04-01'},
        :organisasjonsform=>{:orgform=>'ENK', :orgform_beskrivelse=>'Enkeltpersonforetak',
          :@registrerings_dato=>'2007-12-19'},
        :@tjeneste=>'hentBasisdataMini'
      }
    when '923609016'
      {
        :organisasjonsnummer=>'923609016',
        :navn=>{:navn1=>'STATOIL ASA', :@registrerings_dato=>'2009-11-02'},
        :forretnings_adresse=> {:adresse1=>'Forusbeen 50', :postnr=>'4035', :poststed=>'STAVANGER',
           :kommunenummer=>'1103', :kommune=>'STAVANGER', :landkode=>'NOR', :land=>'Norge',
           :@registrerings_dato=>'2012-09-22'},
        :post_adresse=> {:adresse1=>'Postboks 8500', :postnr=>'4035', :poststed=>'STAVANGER',
           :kommunenummer=>'1103', :kommune=>'STAVANGER', :landkode=>'NOR', :land=>'Norge',
           :@registrerings_dato=>'2012-06-02'},
        :organisasjonsform=>{ :orgform=>'ASA', :orgform_beskrivelse=>'Allmennaksjeselskap'},
        :@tjeneste=>'hentBasisdataMini'
      }
    else
      raise "Don't have any data for orgnr #{orgnr}"
    end
  end
  # rubocop:enable all
end

RSpec.configure do |config|
  config.include FixtureHelper
end
