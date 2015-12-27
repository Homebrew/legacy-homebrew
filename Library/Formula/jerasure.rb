class Jerasure < Formula
  desc "Library in C that supports erasure coding in storage applications"
  homepage "http://jerasure.org/"
  url "http://lab.jerasure.org/jerasure/jerasure/repository/archive.tar.gz?ref=v2.0"
  version "2.0"
  sha256 "61b2fbb25affeddc2d94d6f67778098597b14ff5440f39d8fba3dbdbaa6739b6"

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "gf-complete"

  def install
    system "autoreconf", "--force", "--install"
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system bin/"jerasure_01", "2", "5", "3"
  end
end
