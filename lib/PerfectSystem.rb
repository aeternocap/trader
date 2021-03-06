module Stocks
  # this system calculates the maximum possible R-return by examining the future, using only closing prices
  # intraday high-low prices are assumed to not be capturable
  class PerfectSystem
    def initialize(params = {})
      @params = params
    end

    def params=(new_params)
      @params = new_params
    end

    def params
      @params
    end

    def enter?(day, fullData)
      ind = fullData.find_index(day)
      if ind != fullData.count - 1
        return true #always have money in the market if you know what's about to happen
      else
        return false
      end
    end
    
    def entry(day, fullData)
      ind = fullData.find_index(day)
      if day.close < fullData[ind+1].close # if today's price is less than tomorrow's
        return {price: day.close, stop: day.close - (day.close*0.02)} # buy the stock
      else # if today's price is more than tomorrow's
        return {price: day.close, stop: day.close + (day.close*0.02)} # short the stock
      end
    end
    
    def exit?(day, fullData, entry)
      true #always exit, cause we can just get back in at the same price
    end

    # returns R gain/loss from trade. assumes exit on close
    def exit(day, fullData, entry)
      if entry[:price] > entry[:stop]  #was a buy trade
        return {
                 r: (day.close - entry[:price]) / (entry[:price] - entry[:stop]),
                 percent: (day.close - entry[:price]) / entry[:price]
               }
      else  # was a short sale trade
        return {
                 r: (entry[:price] - day.close) / (entry[:stop] - entry[:price]),
                 percent: (entry[:price] - day.close) / entry[:price]
               }
      end
    end

  end
end
