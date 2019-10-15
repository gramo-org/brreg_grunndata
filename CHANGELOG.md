## v.0.1.8 (to be released)

## v.0.1.7 (to be released)

* CHORE: Updated URL to SOAP service. Old endpoint has EOL 15th of November 2019.

## v.0.1.6
* FIXED: Issue where organization name was not read completely.

## v.0.1.5
* FIXED: Issue with service and hent_saerlige_opplysninger when client returned one line.

## v.0.1.4

* FIXED: Returned address to_h includes street attribute.

## v.0.1.3

* FIXED: Returned address to_hash includes street attribute.

## v.0.1.2

* FIXED: Returned address from service now includes all parts of the street.

## v.0.1.1

* ADDED: `hent_saerlige_opplysninger` to the service layer.
* ADDED: client spec for `hent_saerlige_opplysninger`.

## v.0.1.0

* First release. Includes config, client and a higher level service.
* Service supports operations `hent_basisdata_mini` and `hent_kontaktdata`.
* Clients supports operations `hent_basisdata_mini`, `hent_kontaktdata`,
  `sok_enhet`, `hent_saerlige_opplysninger` and
  `hent_opplysninger_tilknyttet_register`.
