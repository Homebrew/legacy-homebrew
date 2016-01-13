class Profanity < Formula
  desc "Console based XMPP client"
  homepage "http://www.profanity.im/"
  url "http://www.profanity.im/profanity-0.4.7.tar.gz"
  sha256 "b02c4e029fe84941050ccab6c8cdf5f15df23de5d1384b4d1ec66da6faee11dd"
  revision 1

  head "https://github.com/boothj5/profanity.git"

  bottle do
    sha256 "70f475b74b55664d8110ed890211f5dc2adc0c9c0975a18c21da618160a3ee76" => :el_capitan
    sha256 "31280fd909c4cfb6902dd2de6f91be7b0e186bcb28a437bd5f71f1a67bed8a75" => :yosemite
    sha256 "332ab3be6943b2f1df0dbbb9c47363ab0acf07ba5d64c1c30afe70c07bf96a17" => :mavericks
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
