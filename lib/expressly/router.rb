require "base64"

module Expressly

  class Router
    ##
    # Initialise the router, feeds can either be injected through here or through
    # the add_feed() method.
    #
    # == Args
    #
    # * +apiKey+ - your expressly api key 
    # * +provider+ - your MerchantPluginProvider implementation
    #
    def initialize(apiKey, api, provider) 
      @apiKey = apiKey
      @api = api
      @provider = provider
      @expectedAuthorizationHeader = 'Basic ' + Base64.encode64(apiKey)
      self.freeze        
    end
    
    def route(requestMethod, requestUri, requestBody)
    end
    
    def ping()
    end
    
  end
  
end

#private final String expresslyApiKey;
#private final String expectedAuthorizationHeader;
#private final MerchantServiceProvider provider;
#private final ObjectMapper mapper;
#
#public MerchantServiceRouter(String expresslyApiKey, MerchantServiceProvider provider) {
#    this.expresslyApiKey = Objects.requireNonNull(expresslyApiKey, "expresslyApiKey is null");
#    this.provider = Objects.requireNonNull(provider, "provider is null");
#    this.expectedAuthorizationHeader = "Basic " + DatatypeConverter.printBase64Binary(expresslyApiKey.getBytes());
#    this.mapper = new ObjectMapper();
#}
#
#public void route(HttpServletRequest request, HttpServletResponse response) throws IOException {
#    MerchantServiceRoute route = MerchantServiceRoute.findRoute(
#            request.getMethod(),
#            request.getRequestURI());
#
#    if (route.isAuthenticated() && !isAuthenticated(request)) {
#        response.sendError(HttpServletResponse.SC_UNAUTHORIZED);
#        return;
#    }
#
#    switch (route) {
#        case PING:
#            ping(request, response);
#            break;
#        case DISPLAY_POPUP:
#            displayPopup(request, response);
#            break;
#        case GET_CUSTOMER:
#            getCustomer(request, response);
#            break;
#        case GET_INVOICES:
#            getInvoices(request, response);
#            break;
#        case CHECK_EMAILS:
#            checkEmails(request, response);
#            break;
#        default:
#            throw new IllegalArgumentException(String.format(
#                    "invalid expressly merchant route, httpMethod=%s, uri=%s",
#                    request.getMethod(),
#                    request.getRequestURI()));
#    }
#}
#
#private boolean isAuthenticated(HttpServletRequest request) {
#    return expectedAuthorizationHeader.equals(request.getHeader("Authorization"));
#}
#
#private void displayPopup(HttpServletRequest request, HttpServletResponse response) {
#    throw new NotImplementedException();
#}
#
#private void getCustomer(HttpServletRequest request, HttpServletResponse response) {
#    throw new NotImplementedException();
#}
#
#private void checkEmails(HttpServletRequest request, HttpServletResponse response) {
#    throw new NotImplementedException();
#}
#
#private void ping(HttpServletRequest request, HttpServletResponse response) throws IOException {
#    PingResponse providerResponse = provider.ping(new PingRequest());
#    mapper.writeValue(response.getWriter(), providerResponse);
#}
#
#private void getInvoices(HttpServletRequest request, HttpServletResponse response) throws IOException {
#    InvoiceListRequest providerRequest = mapper.readValue(request.getReader(), InvoiceListRequest.class);
#    InvoiceListResponse providerResponse = provider.getInvoices(providerRequest);
#    mapper.writeValue(response.getWriter(), providerResponse);
#}
