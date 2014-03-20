require "formula"

class Rcsslogplayer < Formula
  homepage "http://sserver.sourceforge.net/"
  url "https://downloads.sourceforge.net/sserver/rcsslogplayer/15.1.0/rcsslogplayer-15.1.0.tar.gz"
  sha1 "f1a4140ca98a642e87ea8862c9dcfc6b335df008"

  bottle do
    sha1 "e14d2392e672bd1497dd3f7199dee35d413b0afe" => :mavericks
    sha1 "40532bbf785d987c7417c6914708e2497127318c" => :mountain_lion
    sha1 "e5f256e90585f06e9767d0ea6031fcff691dbf24" => :lion
  end

  depends_on "pkg-config" => :build
  depends_on "qt"
  depends_on "boost"

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "#{bin}/rcsslogplayer --version | tail -1 | grep 'rcsslogplayer Version #{version}'"
  end
end
