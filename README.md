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
- The project was presented on the [re:publica 2012](http://re-publica.de/12/panel/dyi-barrierefreiheit/)


## Installation → the plain old way
The command line is your friend:


    $ git clone git@github.com:sozialhelden/brokenlift.git
    $ cd brokenlift
    $ bundle install
    $ bundle exec rake db:create
    $ bundle exec rake db:migrate
    $ bundle exec rails s


Although [Rails](http://rubyonrails.org/ "Rails") is a great open-source web framework, you still
can get into trouble to create the correct development environment on your machine. So please consult
[stackoverflow](http://stackoverflow.com/ "stackoverflow") or [duckduck](http://duckduckgo.com/
"duckduck").


After you have installed everything it's time to fill the database with some random data. Please
perfom `bundle exec rake db:populate`.


## Installation → the shiny new way
We use [Vagrant](http://vagrantup.com/ "Vagrant") to setup a virtual machine which acts like our
production system with all the dependencies. Once set, you check out the brokenlift repository on
github, put it in the share folder between the virtual machine (guest system) and your machine (host
machine). You can then use your favorite editor to make changes - they will be automatically
deployed on the virtual machine. If you want to see your changes locally, you have to connect to the
virtual machine with and start the rails project.


Enough of the theory, lets make this dream come true. Go through each step:


**Install** the [Oracle’s VirtualBox](http://www.virtualbox.org/wiki/Downloads "Oracle’s VirtualBox")
  for your operating system


**Install** the [vagrant gem](https://rubygems.org/gems/vagrant "vagrant gem"):


    $ gem install vagrant


**Create** a directory for your Virtual Machine:


    $ mkdir $HOME/vagrant_brokenlifts/
    $ cd $HOME/vagrant_brokenlifts/


**Download** the box (→ this will take a while, so grab a snickers):


    $ vagrant box add brokenlifts_box http://www.itmbs.com/package.box


**Initialize** and **run** the virtual machine:


    $ vagrant init brokenlifts_box
    $ vagrant up


**Make** a test login in the box:


    $ vagrant ssh
    Linux lucid32 2.6.32-33-generic #70-Ubuntu SMP Thu Jul 7 21:09:46 UTC 2011 i686 GNU/Linux
    Ubuntu 10.04.3 LTS

    Welcome to Ubuntu!
     * Documentation:  https://help.ubuntu.com/
    Last login: Thu Jul 21 13:07:53 2011 from 10.0.2.2
    vagrant@lucid32:~$


**Install** the guest edition for better handling and reload the VM (don't forget to terminate the
ssh session with `exit` before doing the following steps)


    $ gem install vagrant-vbguest
    $ vagrant reload


**Check** out the current code


    $ git clone git@github.com:sozialhelden/brokenlift.git


**Change the database.yml** this step is necessary because the socket location is different between
the virtual machine and the production system


    $ vagrant ssh
    $ vagrant@lucid32:~$ cd /vagrant/brokenlift
    $ rm config/database.yml
    $ mv config/database_vm.yml config/database.yml


**Create** the database and **start** rails:


    $ vagrant ssh
    vagrant@lucid32:~$ cd /vagrant/brokenlift
    vagrant@lucid32:~$ bundle exec rake db:populate
    vagrant@lucid32:~$ bundle exec rails s


**Browser** check on your browser the URL *http://localhost:3000*


Under `/vagrant` you can find the same file you have under `$HOME/vagrant_brokenlifts/` - that's why
it is called a shared folder. Any change you made under `$HOME/vagrant_brokenlifts/brokenlift` are
influencing the folder on your virtual machine `/vagrant/brokenlift`.


If you want, you can use the *Vagrantfile* in this repository to create own virtual machine.


## API
The project features a RESTful API which can be used to extract the scraped data.  The default
response format is JSON but other formats are also supported.

You can find it int the [wiki](https://github.com/sozialhelden/brokenlift/wiki/API).


## Screenshot
The screenshot shows the current version of the website.

![BrokenLifts Website](https://github.com/sozialhelden/brokenlift/raw/master/screenshot.png "BrokenLifts Website")


## Current Contributers
- [Christoph Bünte](http://christophbuente.de "Christoph Bünte") ([@chris\_can\_do](https://twitter.com/#!/chris_can_do/ "@chris_can_do"))
- [Janosch Woschitz](http://janosch.woschitz.org "Janosch Woschitz") ([@jwoschitz](https://twitter.com/#!/jwoschitz "@jwoschitz"))
- [Oliver Schmidt](http://www.thecodejet.de/blog "Oliver Schmidt") ([@codejet](https://twitter.com/#!/codejet "@codejet"))
- [Matthias Günther](http://wikimatze.de "Matthias Günther") ([@wikimatze](https://twitter.com/#!/wikimatze "@wikimatze"))
- [Esther Masermann](http://esther-masemann.com "Esther Masermann")
- [Andi Weiland](http://ohrenflimmern.de "Andi Weiland") ([@ohrenflimmern](https://twitter.com/#!/ohrenflimmern "@ohrenflimmern"))
- [Raul Krauthausen](http://raul.de "Raul Krauthausen") ([@RAULDe](https://twitter.com/#!/RAULde "@RAULDe"))


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

