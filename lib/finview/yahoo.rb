require "faraday"

module FinView
  module Yahoo
    BASE_URL = "https://query1.finance.yahoo.com/v7/finance/quote?lang=en-US&region=US&corsDomain=finance.yahoo.com&symbols="

    def self.hi
      "hello, yahoo"
    end

    def self.quote(symbol)
      raise ArgumentError.new "Expected string of stock symbol" unless symbol.is_a? String
      raise FinView::SymbolError.new "No symbol given" if symbol.nil? || symbol.empty?

      response = Faraday.get(quote_url(symbol))

      json = JSON.parse(response.body)
      json["quoteResponse"]["result"].first
    end

    def self.quotes(symbols = [])
      raise ArgumentError.new "Expected array of stock symbols" unless symbols.is_a? Array
      raise FinView::SymbolError.new "No symbol given" if symbols.nil? || symbols.empty?

      response = Faraday.get(quote_url(symbols.join(",")))

      json = JSON.parse(response.body)
      json["quoteResponse"]["result"]
    end

    def self.quote_url(symbol_str)
      "#{BASE_URL}#{symbol_str}"
    end
  end
end
