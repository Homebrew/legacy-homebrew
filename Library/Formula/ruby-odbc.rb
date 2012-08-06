require 'formula'

class RubyOdbc < Formula
  homepage 'http://www.ch-werner.de/rubyodbc/'
  url 'http://www.ch-werner.de/rubyodbc/ruby-odbc-0.99994.tar.gz'
  sha1 'ab6e1dffce112e552fdcdf44868fdf09a79904ac'

  depends_on 'unixodbc'
  depends_on 'freetds'

  def install
    # extconf.rb assumes it will install ruby-odbc within a folder in your
    # current ruby installation.
    system "ruby", "-Cext", "extconf.rb", "--enable-dlopen", "--with-odbc-dir=#{HOMEBREW_PREFIX}/lib"

    # The following modifications to the Makefile ensure that it is installed
    # within your homebrew directories.
    inreplace 'ext/Makefile' do |s|
      s.change_make_var! "prefix", prefix
      s.change_make_var! "sitearchdir", lib

      if MacOS.prefer_64_bit?
        # ruby-odbc still chooses iODBC over unixODBC (even with --with-odbc-dir)
        # apparently because unixODBC is compiled for only x86_64 and ruby-odbc
        # and iODBC are both i386 and x86_64. The solution (which works for me on Snow Leopard)
        # is to remove i386 references from ruby-odbc's makefile. YMMV.
        s.change_make_var! "CFLAGS", "-fno-common -arch x86_64 -g -Os -pipe -DENABLE_DTRACE $(cflags)"
        s.change_make_var! "ldflags", "-L. -arch x86_64"
        s.change_make_var! "LDSHARED", "cc -arch x86_64 -pipe -bundle -undefined dynamic_lookup"
        s.change_make_var! "LIBS", "$(LIBRUBYARG_SHARED) -lodbcinst -lodbc  -lpthread -ldl"
      end
    end

    lib.mkpath
    system 'make -C ext'
    system 'make -C ext install'
  end

  def caveats; <<-EOS
Installed #{lib}/odbc.bundle

You will need to add this to your RUBYLIB by adding the following line to
.profile or .bashrc or equivalent:

    export RUBYLIB="#{HOMEBREW_PREFIX}/lib:$RUBYLIB"

You will need to edit freetds.conf, odbcinst.ini and odbc.ini files to set up
access to your odbc databases.
    EOS
  end
end
