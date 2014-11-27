require "formula"

class Profanity < Formula
  homepage "http://www.profanity.im/"
  url "http://www.profanity.im/profanity-0.4.5.tar.gz"
  sha1 "d9eb1b9d6a674d5f49e03882f80d1c5cf98c3ce1"
  head "https://github.com/boothj5/profanity.git"

  bottle do
    sha1 "f53fc5631fa1b079414420275278e55d6225798d" => :yosemite
    sha1 "240feb4c76b4ddb3170792710fa011cb90c302d4" => :mavericks
    sha1 "2c5d854f76597d6b0aa55f4daad3aad3027f3bc4" => :mountain_lion
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
