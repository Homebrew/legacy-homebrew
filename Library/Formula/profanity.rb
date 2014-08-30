require "formula"

class Profanity < Formula
  homepage "http://www.profanity.im/"
  url "http://www.profanity.im/profanity-0.4.4.tar.gz"
  sha1 "c9b8472ccdefc8d3a24c06a4ee9a3f6b0b75794d"
  head "https://github.com/boothj5/profanity.git"

  bottle do
    sha1 "60efcafb41f98c6c19e3404b536fdc405b2f42fb" => :mavericks
    sha1 "e7e4ecc29339d07e9e898b0c93a887a0007f42aa" => :mountain_lion
    sha1 "040472aa3b48d4470fb652b3ce16c73e5c88983b" => :lion
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
