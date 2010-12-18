require 'formula'

class Dbslayer <Formula
  url 'http://code.nytimes.com/downloads/dbslayer-beta-12.tgz'
  homepage 'http://code.nytimes.com/projects/dbslayer/wiki'
  md5 'a529ea503c244d723166f78c75df3bb3'
  version '0.12.b'

  def install
    unless `/usr/bin/which mysql_config`.size > 0
      opoo "No MySQL client library detected"
      puts "This formula may fail to build, see caveats for more information."
    end

    system "./configure", "--prefix=#{prefix}"
    system "make"
    system "make install"
  end

  def caveats
    <<-EOS.undent
    DBSlayer depends on a MySQL client library.

    You can install this with Homebrew using:
      brew install mysql
        For MySQL server.

      brew install mysql-connector-c
        For MySQL client libraries only.

    We don't install these for you when you install this formula, as
    we don't know which datasource you intend to use.
    EOS
  end
end
