class DfuUtil < Formula
  desc "USB programmer"
  homepage "http://dfu-util.sourceforge.net/"
  # Upstream moved, no releases yet, using debian mirror until then.
  # (see #34047 and #39181)
  url "http://ftp.de.debian.org/debian/pool/main/d/dfu-util/dfu-util_0.8.orig.tar.gz"
  sha256 "55cbde9be12a212bd84bce9d1e63941d9a16139ed0d4912401367eba1502f058"

  bottle do
    cellar :any
    sha256 "91eb66e5c5b113995ced22a67a2ab8bffb1d21f6f17d4d8c97564e86af43d768" => :el_capitan
    sha1 "285f3043fe09291b4485fe3c4dac36025489bca8" => :yosemite
    sha1 "ed8be24bc65f7fc2791c42311be08f67649b6e23" => :mavericks
    sha1 "cd533314e4700a3d746330b12aa08407f693d7a4" => :mountain_lion
  end

  head do
    url "git://git.code.sf.net/p/dfu-util/dfu-util"
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
    system "make", "install"
  end

  test do
    system bin/"dfu-util", "-V"
    system bin/"dfu-prefix", "-V"
    system bin/"dfu-suffix", "-V"
  end
end
