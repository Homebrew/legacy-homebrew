require 'formula'

class Bmon < Formula
  homepage 'https://github.com/tgraf/bmon'

  url "https://github.com/tgraf/bmon/releases/download/v3.3/bmon-3.3.tar.gz"
  sha1 "f21d7fc70fdc140680f7ef466242d876474ed2aa"

  bottle do
    sha1 "a5a4f7baad07a9c86ccb0a84b6404cbf9753f204" => :mavericks
    sha1 "fe23553876a3699ce122e9b4f6ef30ca807104df" => :mountain_lion
    sha1 "a926a43c20a7f774365d9f27a8d059b1507d709c" => :lion
  end

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
