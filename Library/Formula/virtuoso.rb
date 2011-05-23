require 'formula'

class Virtuoso < Formula
  url 'http://downloads.sourceforge.net/project/virtuoso/virtuoso/6.1.2/virtuoso-opensource-6.1.2.tar.gz'
  homepage 'http://virtuoso.openlinksw.com/wiki/main/'
  md5 '0519e1f104428e0c8b25fad89e3c57ef'

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
