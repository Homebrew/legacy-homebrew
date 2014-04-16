require 'formula'

# Originally:
#   homepage 'http://www.spinnaker.de/lbdb/'

class Lbdb < Formula
  homepage 'https://github.com/tgray/lbdb/'
  url 'https://github.com/tgray/lbdb/archive/v0.38.2.tar.gz'
  sha1 '2a278fe7bffad6e7572c1c76f9568e4737c68e07'

  head 'https://github.com/tgray/lbdb.git'

  if MacOS.version >= :mountain_lion
    patch do
      url "https://github.com/chrisbarrett/lbdb/commit/db0440670194568bbfe2137fc063eb30cf26cb2a.diff"
      sha1 "8de0fdcfa5cd73a456b150e19cdad572aa8f0d7c"
    end

    patch do
      url "https://github.com/chrisbarrett/lbdb/commit/b89ac6ee50e2c03c32635269d9818c045b0abb6f.diff"
      sha1 "574268f5d7cce1a6dd26e973ff96787c322597a3"
    end

    patch do
      url "https://github.com/chrisbarrett/lbdb/commit/6cbef5feb4fd921deb08eb52b4169647909946ae.diff"
      sha1 "fe7024dc7576e0d885335a4829edf8dde09b22ea"
    end
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
