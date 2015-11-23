class Sparkey < Formula
  desc "Constant key-value store, best for frequent read/infrequent write uses"
  homepage "https://github.com/spotify/sparkey/"
  url "https://github.com/spotify/sparkey/archive/sparkey-0.2.0.tar.gz"
  sha256 "a06caf23c64e7ebae5b8b67272b21ab4c57f21a66d190bfe0a95f5af1dc69154"

  bottle do
    cellar :any
    sha256 "b98eb670ea094ed0657f213fe83bf0f67ee4fea26a2bb5cd50f4eadfbea8bffb" => :mavericks
    sha256 "45463695180f13b78db4ad0e1c7f901636799eaaa59a16678ec1baabdecb4bb9" => :mountain_lion
    sha256 "3197c9a2871ae2d9674ffc1321b3e66d66eac860b237498699c19a3920b8748d" => :lion
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "snappy"

  def install
    system "autoreconf", "--install"
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "#{bin}/sparkey createlog -c snappy test.spl"
    system "echo foo.bar | #{bin}/sparkey appendlog -d . test.spl"
    system "#{bin}/sparkey writehash test.spl"
    system "#{bin}/sparkey get test.spi foo | grep ^bar$"
  end
end
