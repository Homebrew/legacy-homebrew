require "formula"

class Check < Formula
  homepage "http://check.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/check/check/0.9.13/check-0.9.13.tar.gz"
  sha1 "09f682d2239b1353818b74d06099a17460450240"

  bottle do
    cellar :any
    sha1 "b45d891cddd1195e4305b835d13ddd15af2032f5" => :mavericks
    sha1 "ebb33f4679b75836f0dcd47cb5b75ef25967563d" => :mountain_lion
    sha1 "b4065b8bd5e2649070d5ca69f205b47d481be634" => :lion
  end

  option :universal

  def install
    ENV.universal_binary if build.universal?
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
