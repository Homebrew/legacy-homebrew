require "formula"

class DfuUtil < Formula
  homepage "https://gitorious.org/dfu-util/community"
  # upstream moved, no releases yet, using debian mirror until then.  see #34047
  url "http://ftp.de.debian.org/debian/pool/main/d/dfu-util/dfu-util_0.8.orig.tar.gz"
  sha1 "164551ca40f0c569eb7ae3263a9945a1ef3fed4d"

  bottle do
    cellar :any
    sha1 "285f3043fe09291b4485fe3c4dac36025489bca8" => :yosemite
    sha1 "ed8be24bc65f7fc2791c42311be08f67649b6e23" => :mavericks
    sha1 "cd533314e4700a3d746330b12aa08407f693d7a4" => :mountain_lion
  end

  head do
    url "git://gitorious.org/dfu-util/dfu-util.git"
    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "pkg-config" => :build
  depends_on "libusb"

  def install
    system "./autogen.sh" if build.head?
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
