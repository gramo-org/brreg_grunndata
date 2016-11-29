# BRREG / Enhetsregisteret Grunndata

Ruby wrapper for brreg / enhetsregisteret's [soap web service](https://www.brreg.no/produkter-og-tjenester/bestille/tilgang-til-enhetsregisteret-via-web-services/).

[![Build Status](https://snap-ci.com/gramo-org/brreg_grunndata/branch/master/build_image)](https://snap-ci.com/gramo-org/brreg_grunndata/branch/master)

# Usage

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

# Web service documentation
For a better understanding of what to expect of `response.header`
and `response.message` please take a look at [this page from brreg](https://www.brreg.no/produkter-og-tjenester/bestille/tilgang-til-enhetsregisteret-via-web-services/teknisk-beskrivelse-web-services/grunndataws/).
