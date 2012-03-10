require 'formula'

class Virtuoso < Formula
  url 'http://downloads.sourceforge.net/project/virtuoso/virtuoso/6.1.4/virtuoso-opensource-6.1.4.tar.gz'
  homepage 'http://virtuoso.openlinksw.com/wiki/main/'
  md5 '7110a0b4b171b84850d346f4fe648172'

  # If gawk isn't found, make fails deep into the process.
  depends_on 'gawk'

  skip_clean :all

  def install
    ENV.m64 if MacOS.prefer_64_bit?
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make install"
  end

  def caveats; <<-EOS.undent
    NOTE: the Virtuoso server will start up several times on port 1111
    during the install process.
    EOS
  end
end
