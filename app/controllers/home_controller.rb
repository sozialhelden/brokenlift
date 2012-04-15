class HomeController < ApplicationController
  def index

  end

  def about
  end

  def report
    @bvg_phonenumber = '+49-30-25622096'
    @bvg_address = 'http://www.bvg.de/index.php/de/9466/name/Aufzugsmeldungen.html'

    @tam_phonenumber = '+49-30-29743333'
    @tram_address = 'http://www.s-bahn-berlin.de/kontakt/index.htm'

    @twitter_account = 'https://twitter.com/#!/brokenlifts'
  end

end

