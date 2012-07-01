require 'formula'

class Geocouch < Formula
  homepage 'https://github.com/couchbase/geocouch'
  head 'https://github.com/couchbase/geocouch.git', :tag => 'couchdb1.2.x'
  url 'https://github.com/couchbase/geocouch/zipball/couchdb1.2.x'
  sha1 'ec9d912f39710b69115b6d0dae6277e387215377'

  devel do
    url 'https://github.com/couchbase/geocouch.git', :tag => 'master'
    version '1.3.x'
  end

  def couchdb_share
    HOMEBREW_PREFIX/'share/couchdb'
  end
  def geocouch_share
    HOMEBREW_PREFIX/'share/geocouch'
  end

  #  Leverage generic couchdb.rb formula for couchdb (and therefore geocouch)
  #  dependencies.
  depends_on 'couchdb'

  #  GeoCouch currently supports couch_version(s) 1.1.x and 1.2.x (other
  #  versions at your own risk).  This formula supports GeoCouch 1.2.0 on top
  #  of Apache couchdb 1.2.0.
  def install
    #  Grab couchdb 1.2.x.
    couchdb_dir = buildpath/'couchdb-src'
    couchdb = Formula.factory 'couchdb'
    couchdb.brew { couchdb_dir.install Dir['*'] }
    ENV['COUCH_SRC'] = couchdb_dir/"src/couchdb"

    #  Build geocouch.
    system "make"

    #  Install geocouch build files.
    (share/'geocouch').mkpath
    rm_rf share/'geocouch/ebin/'
    (share/'geocouch').install Dir['ebin']

    #  Install geocouch.plist for launchctl support.
    (share/'geocouch').install Dir[couchdb_dir/'etc/launchd/org.apache.couchdb.plist.tpl.in']
    mv share/'geocouch/org.apache.couchdb.plist.tpl.in', share/'geocouch/geocouch.plist'
    inreplace (share/'geocouch/geocouch.plist'), '<string>org.apache.couchdb</string>', \
      '<string>geocouch</string>'
    inreplace (share/'geocouch/geocouch.plist'), '<key>HOME</key>', <<-EOS.lstrip.chop
      <key>ERL_FLAGS</key>
      <string>-pa #{geocouch_share}/ebin</string>
      <key>HOME</key>
    EOS
    inreplace (share/'geocouch/geocouch.plist'), '%bindir%/%couchdb_command_name%', \
      HOMEBREW_PREFIX/'bin/couchdb'
    #  Turn off RunAtLoad and KeepAlive (to simplify experience for first-timers).
    inreplace (share/'geocouch/geocouch.plist'), '<true/>', \
      '<false/>'
    (share/'geocouch/geocouch.plist').chmod 0644

    #  Install geocouch.ini into couchdb.
    (etc/'couchdb/default.d').install Dir['etc/couchdb/default.d/geocouch.ini']

    #  Install tests into couchdb.
    test_files = Dir['share/www/script/test/*.js']
    #  Normal recipe "should" read:
    #      (share/'couchdb/www/script/test/').install test_files
    #  which would symlink geocouch tests into the couchdb share.  But couchdb
    #  seems to sandbox its web-readable files to the share/couchdb/www branch,
    #  and symlinks outside of that folder seem to violate couchdb's
    #  requirements.  Consequently, we have to install geocouch tests directly
    #  inside the share/couchdb/www branch and not symlink them from the
    #  geocouch share branch (i.e., outside the couchdb sandbox).  So for
    #  clarity sake, install/partition all the geocouch tests together into a
    #  tidy subfolder, and symlink them into place in the normal couchdb tests
    #  folder.
    rm_rf (couchdb_share/'www/script/test/geocouch')
    (couchdb_share/'www/script/test/geocouch').mkpath
    (couchdb_share/'www/script/test/geocouch').install test_files
    Dir[(couchdb_share/'www/script/test/geocouch/*.js')].each  \
      { |geotest| system "cd #{couchdb_share/'www/script/test'};  ln -s geocouch/#{File.basename( geotest)} ."}
    #  Complete the install by referencing the geocouch tests in couch_tests.js
    #  (which runs the tests).
    test_lines = test_files.map { |testline| testline.gsub(/^.*\/(.*)$/, 'loadTest("\1");' + "\n") }
    system "(echo;  echo '//REPLACE_ME') >> '#{couchdb_share}/www/script/couch_tests.js'"
    inreplace (couchdb_share/'www/script/couch_tests.js'), /^\/\/REPLACE_ME$/,  \
      "//  GeoCouch Tests...\n#{test_lines}//  ...GeoCouch Tests\n"
  end

  def test
    puts <<-EOS.undent
      To test geocouch, start `couchdb` (with appropriate geocouch ERL_FLAGS)
      in a terminal and then:

        curl http://127.0.0.1:5984/

      The reply should look like:

        {"couchdb":"Welcome","version":"1.2.0"}

      For more thorough testing, use your browser to visit:

        http://127.0.0.1:5984/_utils/couch_tests.html?script/couch_tests.js

      and press the "Run All" button.
      EOS
  end

  def caveats; <<-EOS.undent
    FYI:  geocouch installs as an extension of couchdb, so couchdb effectively
    becomes geocouch.  However, you can use couchdb normally (using geocouch
    extensions optionally).  NB:  one exception:  the couchdb test suite now
    includes several geocouch tests.

    To start geocouch manually and verify any geocouch version information (-V),

      ERL_FLAGS="-pa #{geocouch_share}/ebin"  couchdb -V

    For general convenience, export your ERL_FLAGS (erlang flags, above) in
    your login shell, and then start geocouch:

      export ERL_FLAGS="-pa #{geocouch_share}/ebin"
      couchdb

    Alternately, prepare launchctl to start/stop geocouch as follows:

      cp #{geocouch_share}/geocouch.plist ~/Library/LaunchAgents
      chmod 0644 ~/Library/LaunchAgents/geocouch.plist

      launchctl load ~/Library/LaunchAgents/geocouch.plist

    Then start, check status of, and stop geocouch with the following three
    commands.

      launchctl start geocouch
      launchctl list geocouch
      launchctl stop geocouch

    Finally, access, test, and configure your new geocouch with:

      http://127.0.0.1:5984
      http://127.0.0.1:5984/_utils/couch_tests.html?script/couch_tests.js
      http://127.0.0.1:5984/_utils

    And... relax.

    -=-

    One last thing: to uninstall geocouch from your couchdb installation:

      rm #{HOMEBREW_PREFIX}/etc/couchdb/default.d/geocouch.ini
      unset ERL_FLAGS
      brew uninstall geocouch couchdb;  brew install couchdb

    and restart your couchdb.  (To see the uninstall instructions again, just
    run 'brew info geocouch'.)
    EOS
  end
end
