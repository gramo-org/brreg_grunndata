# frozen_string_literal: true

$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)

require 'brreg_grunndata'

require 'webmock/rspec'
WebMock.disable_net_connect!

module FixtureHelper
  def read_fixture(name)
    path = "#{__dir__}/fixtures/#{name}.xml"
    File.read path, encoding: 'UTF-8'
  rescue Errno::ENOENT
    raise "No fixture file found at: #{path}"
  end

  # rubocop:disable all
  def fixture_hent_basisdata_mini_hash(orgnr: '992090936')
    case orgnr
    when '992090936'
      {
        :organisasjonsnummer=>'992090936',
        :navn=>{:navn1=>'PETER SKEIDE', :navn2=>'CONSULTING', :@registrerings_dato=>'2007-12-19'},
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
    when '991025022'
      {
        :organisasjonsnummer=>"991025022",
        :navn=>{:navn1=>"SKALAR", :navn2=>"AS", :@registrerings_dato=>"2007-03-14"},
        :forretnings_adresse=>{:adresse1=>"4. etasje", :adresse2=>"Kongens gate 11", :postnr=>"0153",
          :poststed=>"OSLO", :kommunenummer=>"0301", :kommune=>"OSLO", :landkode=>"NOR", :land=>"Norge",
          :@registrerings_dato=>"2015-08-13"},
        :organisasjonsform=>{:orgform=>"AS", :orgform_beskrivelse=>"Aksjeselskap",
          :@registrerings_dato=>"2007-03-14"},
        :@tjeneste=>"hentBasisdataMini"
      }
    else
      raise "Don't have any data for orgnr #{orgnr}"
    end
  end

  def fixture_hent_kontaktdata_hash(orgnr: '992090936')
    case orgnr
    when '992090936'
      {
        :organisasjonsnummer=>"992090936",
        :mobiltelefonnummer=>"905 73 014",
        :epostadresse=>"peterskeide@yahoo.no",
        :@tjeneste=>"hentKontaktdata"
      }
    when '923609016'
      {
        :organisasjonsnummer=>"923609016",
        :telefonnummer=>"51 99 00 00",
        :telefaksnummer=>"51 99 00 50",
        :hjemmesideadresse=>"www.statoil.com",
        :@tjeneste=>"hentKontaktdata"
      }
    else
      raise "Don't have any data for orgnr #{orgnr}"
    end
  end

  def fixture_hent_saerlige_opplysninger_hash(orgnr: '')
    case orgnr
    when '992090936'
      {
        :organisasjonsnummer=>"992090936",
        :@tjeneste=>"hentSaerligeOpplysninger"
      }
    when '923609016'
      {
        :organisasjonsnummer=>"923609016",
        :saerlige_opplysninger=> {
          :status=> [
            {:tekst_linje=>"Registrert i Foretaksregisteret", :@registrerings_dato=>"1988-04-28", :@statuskode=>"R-FR"},
            {:tekst_linje=>"Registrert i Merverdiavgiftsregisteret", :@registrerings_dato=>"1995-03-12", :@statuskode=>"R-MV"},
            {:tekst_linje=>["Frivillig registrering i Merverdiavgiftsregisteret:", "- Utleier av bygg eller anlegg"], :@registrerings_dato=>"2014-01-20", :@statuskode=>"FMVA"},
            {:tekst_linje=>"Registrert i NAV Aa-registeret", :@statuskode=>"R-AA"},
            {:tekst_linje=>"Inngår i konsern", :@statuskode=>"KMOR"},
            {:tekst_linje=>"Sist innsendte årsregnskap 2015", :@registrerings_dato=>"2016-06-06", :@statuskode=>"ÅRSO"}
          ]
        },
        :@tjeneste=>"hentSaerligeOpplysninger"
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
