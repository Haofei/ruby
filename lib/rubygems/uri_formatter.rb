# frozen_string_literal: true

##
# The UriFormatter handles URIs from user-input and escaping.
#
#   uf = Gem::UriFormatter.new 'example.com'
#
#   p uf.normalize #=> 'http://example.com'

class Gem::UriFormatter
  ##
  # The URI to be formatted.

  attr_reader :uri

  ##
  # Creates a new URI formatter for +uri+.

  def initialize(uri)
    require "cgi/escape"
    require "cgi/util" unless defined?(CGI::EscapeExt)

    @uri = uri
  end

  ##
  # Escapes the #uri for use as a CGI parameter

  def escape
    return unless @uri
    CGI.escape @uri
  end

  ##
  # Normalize the URI by adding "http://" if it is missing.

  def normalize
    /^(https?|ftp|file):/i.match?(@uri) ? @uri : "http://#{@uri}"
  end

  ##
  # Unescapes the #uri which came from a CGI parameter

  def unescape
    return unless @uri
    CGI.unescape @uri
  end
end
