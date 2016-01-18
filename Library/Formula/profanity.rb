class Profanity < Formula
  desc "Console based XMPP client"
  homepage "http://www.profanity.im/"
  url "http://www.profanity.im/profanity-0.4.7.tar.gz"
  sha256 "b02c4e029fe84941050ccab6c8cdf5f15df23de5d1384b4d1ec66da6faee11dd"
  revision 2

  head "https://github.com/boothj5/profanity.git"

  bottle do
    sha256 "e42d99f8e15de670c0d5d0d3bd90cc946759c6d55697ecf0f20928f8ac63c062" => :el_capitan
    sha256 "01807fbbe872b9921ca8c9af55fc0843ae57bbdeeed565ed929f254523d6f758" => :yosemite
    sha256 "f1e8e071263d364cf86b0adcaf475ef3dabb2cd6eededa8aa1f7e7d4e6fe0c2b" => :mavericks
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
  depends_on "gpgme" => :recommended
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
