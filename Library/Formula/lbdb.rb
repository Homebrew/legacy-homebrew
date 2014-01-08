require 'formula'

# Originally:
#   homepage 'http://www.spinnaker.de/lbdb/'

class Lbdb < Formula
  homepage 'https://github.com/tgray/lbdb/'
  url 'https://github.com/tgray/lbdb/archive/v0.38.2.tar.gz'
  sha1 '2a278fe7bffad6e7572c1c76f9568e4737c68e07'

  head 'https://github.com/tgray/lbdb.git'

  def patches
    p = []
    if MacOS.version >= :mountain_lion
      p << 'https://github.com/chrisbarrett/lbdb/commit/db0440670194568bbfe2137fc063eb30cf26cb2a.diff'
      p << 'https://github.com/chrisbarrett/lbdb/commit/b89ac6ee50e2c03c32635269d9818c045b0abb6f.diff'
      p << 'https://github.com/chrisbarrett/lbdb/commit/6cbef5feb4fd921deb08eb52b4169647909946ae.diff'
    end
    p
  end

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
