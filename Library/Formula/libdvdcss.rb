require "formula"

class Libdvdcss < Formula
  homepage "http://www.videolan.org/developers/libdvdcss.html"
  url "http://download.videolan.org/pub/libdvdcss/1.3.0/libdvdcss-1.3.0.tar.bz2"
  sha1 "b3ccd70a510aa04d644f32b398489a3122a7e11a"

  head "svn://svn.videolan.org/libdvdcss/trunk"

  bottle do
    cellar :any
    sha1 "fe98ffcbc81bc60bf24598bedd91de4bfc99ba09" => :mavericks
    sha1 "bfc883c82af35d57661916d6456ed1a2983f7b73" => :mountain_lion
    sha1 "6169cae9c293189f2e2d2dbe10680af48f76f7db" => :lion
  end

  def install
    system "./bootstrap" if build.head?
    system "./configure", "--prefix=#{prefix}", "--disable-dependency-tracking"
    system "make install"
  end
end
