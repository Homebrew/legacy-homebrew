class Loudmouth < Formula
  desc "Lightweight C library for the Jabber protocol"
  homepage "https://mcabber.com"
  url "https://mcabber.com/files/loudmouth-1.5.0-20121201.tar.bz2"
  version "1.5.0.20121201"
  sha256 "d8ff057dc98c99ab19a68c3890c7f5ab47870e45d67bb65891f01a78c77dfcf9"
  revision 1

  # Fix compilation on 10.9. Sent upstream:
  # https://github.com/mcabber/loudmouth/pull/9
  # Has been merged and will be in next release, if there is one.
  stable do
    patch do
      url "https://github.com/mcabber/loudmouth/commit/369844a0fc.diff"
      sha256 "35fa20c2b91dc470a76db41b67b2f589763aaed7da8537c58a5002a8f896eb09"
    end
  end

  bottle do
    cellar :any
    revision 1
    sha256 "94b43d775245f39b1b5e8e3042a3a9a6b5bda283eb9388f6ba7584e768440ed2" => :el_capitan
    sha256 "de555085936f17c58982b18b54ce5e033255453db378f7475d1aaed86402f58b" => :yosemite
    sha256 "0f790d8960e14b3d1df6de783acf19faaf3dedf95aea8a65cd99490ff115f71b" => :mavericks
  end

  head do
    url "https://github.com/mcabber/loudmouth.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build

    # Fixes configure.ac subdir-objects for recent autoconf version
    # Remove this once the following pull request has been applied to master
    # https://github.com/mcabber/loudmouth/pull/11
    patch do
      url "https://github.com/languitar/loudmouth/commit/f22dd6.diff"
      sha256 "61d341d68fdd867aa40c2130be709809e4ac783a1ff6a2821ed2851243dc6ba3"
    end
  end

  depends_on "pkg-config" => :build
  depends_on "glib"
  depends_on "libidn"
  depends_on "gnutls"

  def install
    system "./autogen.sh", "-n" if build.head?
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}", "--with-ssl=gnutls"
    system "make", "install"
  end
end
