# Originally:
#   homepage 'https://www.spinnaker.de/lbdb/'

class Lbdb < Formula
  desc "Little brother's database for the mutt mail reader"
  homepage "https://github.com/tgray/lbdb/"
  url "https://github.com/tgray/lbdb/archive/v0.38.2.tar.gz"
  sha256 "a125fc304ca17b2ef82e00e59e0480adc9f3beb06ef5448b9010ed39027bc78e"

  bottle do
  end

  head "https://github.com/tgray/lbdb.git"

  if MacOS.version >= :mountain_lion
    patch do
      url "https://github.com/chrisbarrett/lbdb/commit/db0440670194568bbfe2137fc063eb30cf26cb2a.diff"
      sha256 "64c59ec98a60463870e8ffc36655ea308ba6b4ac281709aafae9b598214f35d6"
    end

    patch do
      url "https://github.com/chrisbarrett/lbdb/commit/b89ac6ee50e2c03c32635269d9818c045b0abb6f.diff"
      sha256 "04429944537db843e60fea4c95c45c0879e6c57e3ae9ec119a47bf9347104f4a"
    end

    patch do
      url "https://github.com/chrisbarrett/lbdb/commit/6cbef5feb4fd921deb08eb52b4169647909946ae.diff"
      sha256 "fd27965376e42f358c651d00f3ef7fcf6786e318cae5d1c5104d7c20b8fe4da9"
    end
  end

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  def caveats; <<-EOS.undent
    lbdb from <https://www.spinnaker.de/lbdb/> doesn't build on OS X because the
    Xcode project file is not compatible with Xcode 4 or OS X 10.7.  This
    version of lbdb has been modified to fix this.  A query was sent to the
    upstream maintainer to see if he was interested in the patch, but so far,
    there has been no response.

    The homepage of this version is <https://github.com/tgray/lbdb/>
    EOS
  end
end
