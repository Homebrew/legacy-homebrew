require 'formula'

class RubyOdbc < Formula
  url 'http://www.ch-werner.de/rubyodbc/ruby-odbc-0.9997.tar.gz'
  homepage 'http://www.ch-werner.de/rubyodbc/'
  md5 '36d21519795c3edc8bc63b1ec6682b99'

  depends_on 'unixodbc'
  depends_on 'freetds'

  def install
    system "ruby extconf.rb --enable-dlopen --with-odbc-dir=#{HOMEBREW_PREFIX}/lib"

    # extconf.rb assumes it will install ruby-odbc within a folder in your
    # current ruby installation.
    #
    # The following modifications to the Makefile ensure that it is installed
    # within your homebrew directories.
    inreplace 'Makefile', /^prefix = .*$/, "prefix = #{prefix}"
    inreplace 'Makefile', /^sitearchdir = .*$/, "sitearchdir = #{prefix}/lib"

    system 'make'
    system 'make install'
  end

  def caveats
<<EOS
Installed ruby-odbc into #{prefix}/lib.

You will need to add this to your RUBYLIB by adding the following line to
.profile or .bashrc or equivalent
    export RUBYLIB="#{prefix}/lib:$RUBYLIB"

You will need to edit freetds.conf,	odbcinst.ini and odbc.ini files to set up
access to your odbc databases.
EOS
  end
end
