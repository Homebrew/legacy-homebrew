require 'formula'

class Virtuoso < Formula
  homepage 'http://virtuoso.openlinksw.com/wiki/main/'
  url 'http://downloads.sourceforge.net/project/virtuoso/virtuoso/6.1.5/virtuoso-opensource-6.1.5.tar.gz'
  md5 '61b53395e14a11dd7e7715b50261b9eb'

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
