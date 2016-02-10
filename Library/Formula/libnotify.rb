class Libnotify < Formula
  homepage "https://developer.gnome.org/libnotify"
  url "https://download.gnome.org/sources/libnotify/0.7/libnotify-0.7.6.tar.xz"
  sha256 "0ef61ca400d30e28217979bfa0e73a7406b19c32dd76150654ec5b2bdf47d837"

  bottle do
    sha256 "6c0c8e5b8b9e38ff2820b7df7aefb1510d95a5f9dcb31b37ed800da0c737f4e1" => :el_capitan
    sha256 "c0646c9d0c3b53290875df575a3b97fb30c852a70825e048b70475ed1e9e72d5" => :yosemite
    sha256 "e4f657ff6ecaafa2e448c86521330ba3fbc0ef3181b0608808fe32f03f4fb80c" => :mavericks
  end

  depends_on "pkg-config" => :build
  depends_on "gtk+3"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end
end
