require 'formula'

class Bmon < Formula
  homepage 'https://github.com/tgraf/bmon'
  url "https://github.com/tgraf/bmon/releases/download/v3.5/bmon-3.5.tar.gz"
  sha1 "352f774e20f679e89de0f72159475d999cc7bf2f"

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
