# frozen_string_literal: true
# rubocop:disable Metrics/MethodLength
# rubocop:disable Metrics/AbcSize

require_relative 'organization'

module BrregGrunndata
  module Types
    # Contains methods for extracting datafrom client responses
    # and building defined types from it.
    module FromResponseFactory
      module_function

      # Creates an organization from given response
      #
      # @return BrregGrunndata::Types::Organization
      def organization(response)
        m = response.message

        Organization.new(
          orgnr: m.dig(:organisasjonsnummer),
          name: m.dig(:navn, :navn1),

          business_address: {
            street: m.dig(:forretnings_adresse, :adresse1),
            postal_code: m.dig(:forretnings_adresse, :postnr),
            postal_area: m.dig(:forretnings_adresse, :poststed),
            municipality_number: m.dig(:forretnings_adresse, :kommunenummer),
            municipality: m.dig(:forretnings_adresse, :kommune),
            country_code: m.dig(:forretnings_adresse, :landkode),
            country: m.dig(:forretnings_adresse, :land)
          },

          postal_address: {
            street: m.dig(:post_adresse, :adresse1),
            postal_code: m.dig(:post_adresse, :postnr),
            postal_area: m.dig(:post_adresse, :poststed),
            municipality_number: m.dig(:post_adresse, :kommunenummer),
            municipality: m.dig(:post_adresse, :kommune),
            country_code: m.dig(:post_adresse, :landkode),
            country: m.dig(:post_adresse, :land)
          },

          organizational_form: {
            name: m.dig(:organisasjonsform, :orgform),
            description: m.dig(:organisasjonsform, :orgform_beskrivelse)
          }
        )
      end
    end
  end
end
