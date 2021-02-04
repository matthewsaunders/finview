require "finview/version"
require "finview/yahoo"

module FinView
  class Error < StandardError; end
  class SymbolError < StandardError; end
  class ResponseError < StandardError; end
end
