# frozen_string_literal: true

require_relative 'organization'
require_relative 'organizational_form'
require_relative 'address'
require_relative 'additional_information'

module BrregGrunndata
  module Types
    module Factory
      module_function

      # Creates an organization from given hash
      #
      # rubocop:disable Metrics/MethodLength
      # rubocop:disable Metrics/AbcSize
      #
      # @return BrregGrunndata::Types::Organization
      def organization(h)
        Organization.new(
          orgnr: h.fetch(:organisasjonsnummer),
          organizational_form: organizational_form(h[:organisasjonsform]),

          name: h.dig(:navn, :navn1),

          telephone_number: h[:telefonnummer],
          telefax_number: h[:telefaksnummer],
          mobile_number: h[:mobiltelefonnummer],
          email: h[:epostadresse],
          web_page: h[:hjemmesideadresse],

          business_address: business_address(h[:forretnings_adresse]),
          postal_address: postal_address(h[:post_adresse]),

          additional_information: additional_information(h.dig(:saerlige_opplysninger, :status))
        )
      end
      # rubocop:enable Metrics/MethodLength
      # rubocop:enable Metrics/AbcSize

      # Creates a address for given Hash
      #
      # @return BrregGrunndata::Types::Address
      def business_address(hash)
        __address hash
      end

      # Creates a address for given Hash
      #
      # @return BrregGrunndata::Types::Address
      def postal_address(hash)
        __address hash
      end

      # Creates a organizational form for given Hash
      #
      # @return BrregGrunndata::Types::OrganizationalForm
      def organizational_form(h)
        return nil if h.nil?

        OrganizationalForm.new(
          name: h[:orgform],
          description: h[:orgform_beskrivelse]
        )
      end

      def additional_information(lines)
        Array(lines).map do |line|
          AdditionalInformation.new(
            status_code: line[:@statuskode],
            description: line[:tekst_linje],
            registered_date: line[:@registrerings_dato]
          )
        end
      end

      # As of writing, keys for postal and business address
      # are the same, so the are both initialized here
      def __address(h)
        return nil if h.nil?

        Address.new(
          street_parts: [h[:adresse1], h[:adresse2], h[:adresse3]].compact,
          postal_code: h[:postnr],
          postal_area: h[:poststed],
          municipality_number: h[:kommunenummer],
          municipality: h[:kommune],
          country_code: h[:landkode],
          country: h[:land]
        )
      end
    end

    # Contains methods for extracting datafrom client responses
    # and building defined types from it.
    module FromResponseFactory
      module_function

      # Creates an organization from given response
      #
      # @return BrregGrunndata::Types::Organization
      def organization(response)
        Factory.organization response.message
      rescue Client::Response::MessageEmptyError
        nil
      end
    end
  end
end
