# BRREG / Enhetsregisteret Grunndata

Ruby wrapper for brreg / enhetsregisteret's [soap web service](https://www.brreg.no/produkter-og-tjenester/bestille/tilgang-til-enhetsregisteret-via-web-services/).

[![Build Status](https://snap-ci.com/gramo-org/brreg_grunndata/branch/master/build_image)](https://snap-ci.com/gramo-org/brreg_grunndata/branch/master)

# Usage

This lib exposes a couple of ways getting data from BRREG. You can either use
the `Client` directly which gives direct access to response, it's `#message` (data)
and `#header` (BRREG's status and sub statuses) or you can use the `Service`
which returns data put in predefined types.

## How to use the client

```ruby
# Configure and create a client
config = BrregGrunndata::Configuration.new userid: 'x', password: 'y'
client = BrregGrunndata::Client.new configuration: config

# Make a request and get a response
#
# Calling an operation may raise an error, for instance if you
# are no authenticated.
response = client.hent_basisdata_mini orgnr: '123456789'

# The response has two main methods
# header() returns brreg's "responseHeader"
header = response.header
header.main_status    # An integer
header.sub_statuses   # An array of hashes, contains code (int) and message.

# message() contains the message. It has different data
# corresponding to the operation you called.
#
# Calling message may raise an error, for instance if no
# message is found in the response. You should inspect the
# header before asking for a message.
message = response.message # Returns a hash
```

## How to use the service

```ruby
# You need to have an initialized client, see "How to use the client" above.
service = BrregGrunndata::Service.new client: client

# Get data for a given org number. Will return either the organization or null
# If an error occurs an error will be raised
organization = service.hent_basisdata_mini orgnr: '123456789'

organization.orgnr                    # Not surprisingly the organization number
organization.name                     # The name of this organization
organization.business_address         # An address object, responds to street etc.
organization.organizational_form.name # ENK, ASA, etc
# ..etc
```

### Merge data from different soap operations

```ruby
# Some data are fetched from other soap operations
organization = service.hent_basisdata_mini orgnr: '123456789'

organization.telephone_number   # nil
organization.email              # nil

merged_organization = organization.merge service.hent_kontaktdata orgnr: '123456789'
merged_organization.telephone_number  # 77 66 55 44
merged_organization.email             # 'email@example.com'
```

### Get data efficiently

Data for one organization is spread over multiple operations.
If you want you can use `#service.run_concurrently` to use threads
and execute different operations at the same time. Data returned from
each service will be `#merge`-ed  together.

```ruby
operations = [:hent_basisdata_mini, :hent_kontaktdata]
organization = service.run_concurrently operations, orgnr: '123456789'

organization.name           # Filled from operation hent_basisdata_mini
organization.mobile_number  # Filled from operation hent_kontaktdata
```

# Web service documentation
For a better understanding of what to expect of `response.header`
and `response.message` please take a look at [this page from brreg](https://www.brreg.no/produkter-og-tjenester/bestille/tilgang-til-enhetsregisteret-via-web-services/teknisk-beskrivelse-web-services/grunndataws/).
