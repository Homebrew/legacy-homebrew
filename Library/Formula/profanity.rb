class Profanity < Formula
  desc "Console based XMPP client"
  homepage "http://www.profanity.im/"
  url "http://www.profanity.im/profanity-0.4.7.tar.gz"
  sha256 "b02c4e029fe84941050ccab6c8cdf5f15df23de5d1384b4d1ec66da6faee11dd"
  revision 1

  head "https://github.com/boothj5/profanity.git"

  bottle do
    sha256 "60f8f25246037c9f6cdcb84cbe43af759f0b6cf51ab4e620d4afe395b5539646" => :el_capitan
    sha256 "784dfd72d38ba8d73757d1e78879a808cb2fdae83353bf0d82b65f15c4764c24" => :yosemite
    sha256 "899c799143a688220ff58f1cc4321223bd0ce68b26743460ea21cf73d632d724" => :mavericks
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "pkg-config" => :build
  depends_on "ossp-uuid"
  depends_on "libstrophe"
  depends_on "readline"
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
