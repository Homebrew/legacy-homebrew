require 'brewkit'

class Postgresql <Formula
  @url='http://wwwmaster.postgresql.org/redir/198/h/source/v8.4.0/postgresql-8.4.0.tar.bz2'
  @homepage='http://www.postgresql.org/'
  @md5='1f172d5f60326e972837f58fa5acd130'

  def install

    configure_args = [
        "--enable-thread-safety",
        "--with-bonjour",
        "--with-python",
        "--with-perl",
        "--with-gssapi",
        "--with-krb5",
        "--with-openssl",
        "--with-libxml",
        "--with-libxslt",
        "--prefix=#{prefix}",
        "--disable-debug",
        "--disable-dependency-tracking"
    ]

    if MACOS_VERSION >= 10.6
      configure_args << "ARCHFLAGS='-arch x86_64'"
    end

    system "./configure", *configure_args
    system "make install"

  end

  def skip_clean? path
    # NOTE at some point someone should tweak this so it only skips clean
    # for the bits that break the build otherwise
    true
  end

  def caveats; <<-EOS
Suggested next steps:

    * Create a user for postgresql (we'll name it "postgres"). Do it via System preferences or by running:

    $ sudo dscl . -create /Users/postgres
    $ sudo dscl . -create /Users/postgres Usershell /bin/bash

    * Create a databse:

    $ sudo mkdir -p /var/db/postgresql/defaultdb
    $ sudo chown postgres /var/db/postgresql/defaultdb
    $ sudo su postgres -c '#{HOMEBREW_PREFIX}/bin/initdb -D /var/db/postgresql/defaultdb'

    $ sudo touch /var/log/postgres.log
    $ sudo chown postgres /var/log/postgres.log

Starting:

    $ sudo su postgres -c "#{HOMEBREW_PREFIX}/bin/pg_ctl -D /var/db/postgresql/defaultdb start -l /var/log/postgres.log"

Stopping:

    $ sudo su postgres -c "#{HOMEBREW_PREFIX}/bin/pg_ctl -D /var/db/postgresql/defaultdb stop -s -m fast"

You can also alias the above commands in your bash profile to pg_start and pg_stop.

Google around for org.postgresql.plist if you want launchd support.

If you're wanting to install the postgres gem, include ARCHFLAGS in the gem install to avoid issues:

sudo env ARCHFLAGS="-arch x86_64" gem install postgres
    EOS
  end
end
