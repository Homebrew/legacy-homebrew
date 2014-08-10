require "formula"

class Profanity < Formula
  homepage "http://www.profanity.im/"
  url "http://www.profanity.im/profanity-0.4.3.tar.gz"
  sha1 "ecd99eba84ad149941491c17c7f69a77fc20de5e"
  head "https://github.com/boothj5/profanity.git"

  bottle do
    sha1 "7dcef1770b0ac01814677f714fd7a8d5568cbf34" => :mavericks
    sha1 "26843e609428afb61e0df4b0d2075d09d4ae0d2e" => :mountain_lion
    sha1 "8dc3cc76203dab0fbd6a2b7ff47a88b8a3bb64b2" => :lion
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "pkg-config" => :build
  depends_on "libstrophe"
  depends_on "glib"
  depends_on "openssl"
  depends_on "gnutls"
  depends_on "libotr" => :recommended
  depends_on "terminal-notifier" => :optional

  def install
    system "./bootstrap.sh"
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "profanity", "-v"
  end
end
