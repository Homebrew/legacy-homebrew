require 'formula'
require 'hardware'

class Postgresql <Formula
  homepage 'http://www.postgresql.org/'
  url 'http://ftp2.uk.postgresql.org/sites/ftp.postgresql.org/source/v8.4.3/postgresql-8.4.3.tar.bz2'
  md5 '7f70e7b140fb190f268837255582b07e'

  depends_on 'readline'
  depends_on 'libxml2' if MACOS_VERSION < 10.6 #system libxml is too old

  aka 'postgres'

  def options
    [
      ['--no-python', 'Build without Python support.'],
      ['--no-perl', 'Build without Perl support.']
    ]
  end

  def install
    ENV.libxml2 # wouldn't compile for justinlilly otherwise
    
    configure_args = [
        "--enable-thread-safety",
        "--with-bonjour",
        "--with-gssapi",
        "--with-krb5",
        "--with-openssl",
        "--with-libxml",
        "--with-libxslt",
        "--prefix=#{prefix}",
        "--disable-debug"
    ]

    configure_args << "--with-python" unless ARGV.include? '--no-python'
    configure_args << "--with-perl" unless ARGV.include? '--no-perl'

    if bits_64? and not ARGV.include? '--no-python'
      configure_args << "ARCHFLAGS='-arch x86_64'"

      framework_python = Pathname.new "/Library/Frameworks/Python.framework/Versions/Current/Python"
      if framework_python.exist? and not (archs_for_command framework_python).include? :x86_64
        opoo "Detected a framework Python that does not have 64-bit support:"
        puts "  #{framework_python}"
        puts "You may experience linker problems. See:"
        puts "http://osdir.com/ml/pgsql-general/2009-09/msg00160.html"
        puts
        puts "To build plpython against a specific Python, set PYTHON prior to brewing:"
        puts "  PYTHON=/usr/local/bin/python  brew install postgresql"
        puts "See: http://www.postgresql.org/docs/8.4/static/install-procedure.html"
      end
    end

    # Fails on Core Duo with O4 and O3
    ENV.O2 if Hardware.intel_family == :core

    system "./configure", *configure_args
    system "make install"

    (prefix+'org.postgresql.postgres.plist').write startup_plist
  end

  def skip_clean? path
    # NOTE at some point someone should tweak this so it only skips clean
    # for the bits that break the build otherwise
    true
  end

  def bits_64?
    MACOS_VERSION >= 10.6 && Hardware.is_64_bit?
  end

  def caveats
    caveats = <<-EOS
To build plpython against a specific Python, set PYTHON prior to brewing:
  PYTHON=/usr/local/bin/python  brew install postgresql
See:
  http://www.postgresql.org/docs/8.4/static/install-procedure.html


If this is your first install, create a database with:
    initdb #{var}/postgres

Automatically load on login with:
    launchctl load -w #{prefix}/org.postgresql.postgres.plist

Or start manually with:
    pg_ctl -D #{var}/postgres -l #{var}/postgres/server.log start

And stop with:
    pg_ctl -D #{var}/postgres stop -s -m fast
EOS
    
    if bits_64? then
      caveats << <<-EOS

If you want to install the postgres gem, including ARCHFLAGS is recommended:
    env ARCHFLAGS="-arch x86_64" gem install postgres

To install gems without sudo, see the Homebrew wiki.
      EOS
    end

    caveats
  end

  def startup_plist
    return <<-EOPLIST
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
  <key>KeepAlive</key>
  <true/>
  <key>Label</key>
  <string>org.postgresql.postgres</string>
  <key>ProgramArguments</key>
  <array>
    <string>#{bin}/postgres</string>
    <string>-D</string>
    <string>#{var}/postgres</string>
    <string>-r</string>
    <string>#{var}/postgres/server.log</string>
  </array>
  <key>RunAtLoad</key>
  <true/>
  <key>UserName</key>
  <string>#{`whoami`.chomp}</string>
  <key>WorkingDirectory</key>
  <string>#{HOMEBREW_PREFIX}</string>
</dict>
</plist>
    EOPLIST
  end
end
