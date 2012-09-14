require 'formula'

class Virtuoso < Formula
  homepage 'http://virtuoso.openlinksw.com/wiki/main/'
  url 'http://downloads.sourceforge.net/project/virtuoso/virtuoso/6.1.5/virtuoso-opensource-6.1.5.tar.gz'
  sha1 '83e3061ebf5f554c0ff153030d21c85fe5b5abfb'

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
