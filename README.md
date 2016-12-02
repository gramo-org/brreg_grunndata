# BRREG / Enhetsregisteret Grunndata

Ruby wrapper for brreg / enhetsregisteret's [soap web service](https://www.brreg.no/produkter-og-tjenester/bestille/tilgang-til-enhetsregisteret-via-web-services/).

[![Build Status](https://snap-ci.com/gramo-org/brreg_grunndata/branch/master/build_image)](https://snap-ci.com/gramo-org/brreg_grunndata/branch/master)

# Usage

This lib exposes a couple of ways getting data from BRREG. You can either use
the `Client` directly which gives direct access to response, it's `#message` (data)
and `#header` (BRREG's status and sub statuses) or you can use the `Service`
which returns data as objects where types is defined.

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

organization.organization_number
organization.name
organization.business_address # An address object
# ..etc

# You can access the response if you need to by:
organization.original_response
```

# Web service documentation
For a better understanding of what to expect of `response.header`
and `response.message` please take a look at [this page from brreg](https://www.brreg.no/produkter-og-tjenester/bestille/tilgang-til-enhetsregisteret-via-web-services/teknisk-beskrivelse-web-services/grunndataws/).
