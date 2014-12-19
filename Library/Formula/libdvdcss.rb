require "formula"

class Libdvdcss < Formula
  homepage "http://www.videolan.org/developers/libdvdcss.html"
  url "http://download.videolan.org/pub/libdvdcss/1.3.0/libdvdcss-1.3.0.tar.bz2"
  sha1 "b3ccd70a510aa04d644f32b398489a3122a7e11a"

  head "svn://svn.videolan.org/libdvdcss/trunk"

  bottle do
    cellar :any
    revision 1
    sha1 "7709d75dbacced986314aba9c05f7e9351d9aeca" => :yosemite
    sha1 "dd85bca762d539179011f67a7196bd3a3392abac" => :mavericks
    sha1 "8d1e8dd357ac40b115c785e054041616b79a2d73" => :mountain_lion
  end

  def install
    system "./bootstrap" if build.head?
    system "./configure", "--prefix=#{prefix}", "--disable-dependency-tracking"
    system "make install"
  end
end
