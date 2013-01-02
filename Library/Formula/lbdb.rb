require 'formula'

# Originally:
#   homepage 'http://www.spinnaker.de/lbdb/'

class Lbdb < Formula
  homepage 'https://github.com/tgray/lbdb/'
  url 'https://github.com/tgray/lbdb/tarball/v0.38.1'
  sha1 '4678fe00c86850fd4f40891518a8d37ee3f5020b'

  head 'https://github.com/tgray/lbdb.git'

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end

  def caveats; <<-EOS.undent
    lbdb from <http://www.spinnaker.de/lbdb/> doesn't build on OS X because the
    XCode project file is not compatible with XCode 4 or OS X 10.7.  This
    version of lbdb has been modified to fix this.  A query was sent to the
    upstream maintainer to see if he was interested in the patch, but so far,
    there has been no response.

    The homepage of this version is <https://github.com/tgray/lbdb/>
    EOS
  end
end
