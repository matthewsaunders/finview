RSpec.describe FinView::Yahoo do
  it "works" do
    expect(FinView::Yahoo.hi).to eq("hello, yahoo")
  end

  describe "#quote" do
    before(:each) do
      url = "https://query1.finance.yahoo.com/v7/finance/quote?lang=en-US&region=US&corsDomain=finance.yahoo.com&symbols=AAPL"
      aapl_stub = JSON.parse(File.read(stub_path("aapl_quote.json")))

      stub_request(:get, url).to_return(
        status: 200,
        body: aapl_stub.to_json
      )
    end

    it "raises a ArgumentError if no string is given" do
      expect{ FinView::Yahoo.quote(nil) }.to raise_error(ArgumentError)
    end

    it "raises a SymbolError if no symbol is given" do
      expect{ FinView::Yahoo.quote("") }.to raise_error(FinView::SymbolError)
    end

    it "returns a quote" do
      quote = FinView::Yahoo.quote("AAPL")
      expect(quote["symbol"]).to eq("AAPL")
    end
  end

  describe "#quotes" do
    before(:each) do
      url = "https://query1.finance.yahoo.com/v7/finance/quote?lang=en-US&region=US&corsDomain=finance.yahoo.com&symbols=AAL,AAPL"
      aal_stub = JSON.parse(File.read(stub_path("aal_quote.json")))["quoteResponse"]["result"].first
      aapl_stub = JSON.parse(File.read(stub_path("aapl_quote.json")))["quoteResponse"]["result"].first

      stub_request(:get, url).to_return(
        status: 200,
        body: {
          "quoteResponse": {
            "result": [
              aal_stub,
              aapl_stub
            ]
          }
        }.to_json
      )
    end

    it "raises a ArgumentError if no array is given" do
      expect{ FinView::Yahoo.quotes(nil) }.to raise_error(ArgumentError)
    end

    it "raises a SymbolError if no symbol is given" do
      expect{ FinView::Yahoo.quotes([]) }.to raise_error(FinView::SymbolError)
    end

    it "returns a quote" do
      quotes = FinView::Yahoo.quotes(["AAL", "AAPL"])
      expect(quotes.length).to eq(2)
      expect(quotes[0]["symbol"]).to eq("AAL")
      expect(quotes.last["symbol"]).to eq("AAPL")
    end
  end
end
