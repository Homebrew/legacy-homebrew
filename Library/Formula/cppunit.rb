require "formula"

class Cppunit < Formula
  homepage "http://www.freedesktop.org/wiki/Software/cppunit/"
  url "http://dev-www.libreoffice.org/src/cppunit-1.13.2.tar.gz"
  sha1 "0eaf8bb1dcf4d16b12bec30d0732370390d35e6f"

  bottle do
    cellar :any
    sha1 "2454890509b3b673e6a2bc7f53d755df7d5abb8f" => :mavericks
    sha1 "07ace28a30f222a55adc2cd351524e5c8d8783a1" => :mountain_lion
    sha1 "fcc7a7f99e35235a8cee728a3165d0db4da5dd5c" => :lion
  end

  option :universal

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build

  def install
    ENV.universal_binary if build.universal?
    system "autoreconf", "-fvi"
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make install"
  end
end
