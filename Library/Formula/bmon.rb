require 'formula'

class Bmon < Formula
  homepage 'https://github.com/tgraf/bmon'

  url "https://github.com/tgraf/bmon/releases/download/v3.3/bmon-3.3.tar.gz"
  sha1 "f21d7fc70fdc140680f7ef466242d876474ed2aa"

  head do
    url "https://github.com/tgraf/bmon.git"
    depends_on "autoconf" => :build
    depends_on "automake" => :build
  end

  depends_on "confuse" => :build
  depends_on "pkg-config" => :build

  def install
    system "./autogen.sh" if build.head?
    system "./configure", "--disable-debug",
                          "--prefix=#{prefix}",
                          "--mandir=#{man}"
    system "make" # two steps to prevent blowing up
    system "make install"
  end
end
