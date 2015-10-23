Here is the documentation: http://expressly.readthedocs.org/en/latest/
Our PHP implementation (as inspiration): https://github.com/expressly/php-common

1) Ruby SDK
2) Encapsulated all the Json payloads as objects
3) All module to server endpoints should be implemented and functional
4) All server to module endpoints will be dependent on the web server or e-commerce framework. While the SDK can't implement these, it should provide the scaffolding and utils to minimize the work required by someone implementing the Expressly API in Ruby. This should include but not necessarily be restricted to marshalling and unmarshalling any payloads to / from the encapsulated objects, validation and HTTP header checks for things like authorization headers.
5) Validation should be performed automatically or tools provided to ensure that payloads adhere to the API. This should include checking required fields are present, field value types, lengths and formatting.
6) Unit tests should be included, 100% class coverage, 90%+ method coverage and 75+% branch coverage.