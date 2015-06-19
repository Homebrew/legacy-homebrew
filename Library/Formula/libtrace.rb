require "formula"

class Libtrace < Formula
  desc "Library for trace processing supporting multiple inputs"
  homepage "http://research.wand.net.nz/software/libtrace.php"
  url "http://research.wand.net.nz/software/libtrace/libtrace-3.0.22.tar.bz2"
  sha256 "b8bbaa2054c69cc8f93066143e2601c09c8ed56e75c6e5e4e2c115d07952f8f8"

  bottle do
    revision 1
    sha1 "21ed3acff5c080c76ff0e49f21b7d8e0333478d8" => :yosemite
    sha1 "d2cf23b52f028f5094daef2c0e62c8340927c717" => :mavericks
    sha1 "0e334011d10d9212b30bf633cdadbaa714f90007" => :mountain_lion
  end

  def install
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make"
    system "make install"
  end
end
