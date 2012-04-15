<pre>   ______                              _
  (, /    )        /)              ___/__) ,   /)
    /---(  __  ___(/_   _ __      (, /        // _/_ _
 ) / ____)/ (_(_) /(___(/_/ (_      /    _(_ /(_ (__/_)_
(_/ (                              (_____   /)
                                          )(/
</pre>

BrokenLifts consists of a RubyOnRails API Backend supplying JSON and XML objects retrieved from
the database and the HTML/CSS frontend loading and visualizing the content via JavaScript.


## About

- Public transport operators in Europe must ensure that mobility impaired
  people can use their service. That's why more and more lifts are
  installed at train and subway stations. Broken lifts severly restrict
  the freedom of those people. Being stuck at a train platform not only
  makes a journey much longer, it is also disrespectful to the individual.
- BrokenLifts was born at December 3/4, 2011 at
  [Random Hacks of Kindness, Berlin](http://www.rhok.org/event/berlin-germany). There are pictures taken at
  [RHoK Berlin on Flickr](http://www.flickr.com/photos/tags/rhokbln/). Of course
  [BrokenLifts is on Twitter](https://twitter.com/#!/brokenlifts).
- The project idea was brought to RHoK by Raul Krauthausen from
  [Sozialhelden e.V.](http://sozialhelden.de) The [initial project
  definition](http://www.rhok.org/problems/brokenelevatorsinfo-%E2%80%93-push-faulty-elevators-next-level-public-awareness-deen)
  can still be found online. The
  [slides we used for the final presentation](https://docs.google.com/present/view?id=dds3dksj_407fgx7mchk)
  can be seen on online. Moreover, the project was advertised at the [28th Chaos Communication
  Congress (28C3)](http://events.ccc.de/congress/2011/wiki/Welcome) in Berlin at December 29, 2011. The slides of the
  [28C3 Lightning Talk](http://www.scribd.com/doc/76810936/BrokenLifts) and the
  [video recording](http://youtu.be/JUPMVI5rnOI) are available online.
- The current version of the website is online at: [http://brokenlifts.org](http://brokenlifts.org).


## Installation
The command line is your friend:


    $ git clone git@github.com:sozialhelden/brokenlift.git
    $ cd brokenlift
    $ bundle install
    $ bundle exec rake db:create
    $ bundle exec rake db:migrate
    $ bundle exec rails s


If you have problems with installing the mysql2 gem, comment it in the Gemfile:


    ...
    group :default do
      gem 'pry-rails'
      # gem 'mysql2', '0.3.11'
    ...


If you want to use SQLite instead of MySQL please replace the content `config/database.yml` with the
content of `config/database_sqlite.yml`

## API
The project features a RESTful API which can be used to extract the scraped data. 
The default response format is JSON but other formats are also supported.

You will find a minimalistic but at least up-to-date [API documentation](https://github.com/sozialhelden/brokenlift/wiki/API) in the wiki.

## Screenshot

The screenshot shows the current version of the website.

![BrokenLifts Website](https://github.com/sozialhelden/brokenlift/raw/master/screenshot.png "BrokenLifts Website")


## Current Contributers

- [Christoph Bunte](http://www.christophbuente.de/ "Christoph Bunte") ([@chris\_can\_do](https://twitter.com/#!/chris_can_do/ "@chris_can_do"))
- [Janosch Woschitz](http://janosch.woschitz.org/ "Janosch Woschitz") ([@jwoschitz](https://twitter.com/#!/jwoschitz "@jwoschitz"))
- [Oliver Schmidt](http://www.thecodejet.de/blog/ "Oliver Schmidt") ([@codejet](https://twitter.com/#!/codejet "@codejet"))
- [Matthias Guenther](http://wikimatze.de "Matthias Guenther") ([@wikimatze](https://twitter.com/#!/wikimatze "@wikimatze"))
- [Esther Masermann](http://www.esther-masemann.com/ "Esther Masermann")
- [Andi Weiland](http://www.ohrenflimmern.de/ "Andi Weiland") ([@ohrenflimmern](https://twitter.com/#!/ohrenflimmern "@ohrenflimmern"))
- [Raul Krauthausen](http://raul.de/ "Raul Krauthausen") ([@RAULDe](https://twitter.com/#!/RAULde "@RAULDe"))


## Former Contributors

Brought to you by:

- Julia Benndorf
- Florian Brasch (Awesome logo of awesomeness)
- Holger Dieterich
- Stefan Dühring
- Nick Fisher
- Duc Ngo Viet
- Tobias Preuss
- Marco Stahl

