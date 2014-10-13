require "formula"

class Arpon < Formula
  homepage "http://arpon.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/arpon/arpon/ArpON-2.7.1.tar.gz"
  sha1 "33329ad482a2ffae7140e34daf1c55fdb45b2f5d"

  head "git://git.code.sf.net/p/arpon/code"

  depends_on "cmake" => :build
  depends_on "libdnet"
  depends_on "libnet"

  def install
    system "cmake", ".", *std_cmake_args
    system "make", "install"
  end

  test do
    system "#{sbin}/arpon --version"
  end
end
