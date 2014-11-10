require "formula"

class Profanity < Formula
  homepage "http://www.profanity.im/"
  url "http://www.profanity.im/profanity-0.4.5.tar.gz"
  sha1 "d9eb1b9d6a674d5f49e03882f80d1c5cf98c3ce1"
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
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "profanity", "-v"
  end
end
