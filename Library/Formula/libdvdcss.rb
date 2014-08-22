require "formula"

class Libdvdcss < Formula
  homepage "http://www.videolan.org/developers/libdvdcss.html"
  url "http://download.videolan.org/pub/libdvdcss/1.3.0/libdvdcss-1.3.0.tar.bz2"
  sha1 "b3ccd70a510aa04d644f32b398489a3122a7e11a"

  head "svn://svn.videolan.org/libdvdcss/trunk"

  bottle do
    cellar :any
    sha1 "8ffcf33c522746d5c7547cef30f4b250c9b7a33c" => :mavericks
    sha1 "6b11c8c628c165ee4b18319e7b5da399b13377c9" => :mountain_lion
    sha1 "1b302e402b177f5380247e145658896524c34f6f" => :lion
  end

  def install
    system "./bootstrap" if build.head?
    system "./configure", "--prefix=#{prefix}", "--disable-dependency-tracking"
    system "make install"
  end
end
