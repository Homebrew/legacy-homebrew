require 'formula'

class Cairomm < Formula
  homepage 'http://cairographics.org/cairomm/'
  url 'http://cairographics.org/releases/cairomm-1.10.0.tar.gz'
  sha256 '068d96c43eae7b0a3d98648cbfc6fbd16acc385858e9ba6d37b5a47e4dba398f'
  revision 1

  bottle do
    sha1 "cd8a555f260bb8b8fe8f82e79b19413255df4e04" => :mavericks
    sha1 "76bd3aa998281c12a7b5e936bc3c03462a07e4e6" => :mountain_lion
    sha1 "8640ddb943e78dc271c870d259c079bbbfcba668" => :lion
  end

  option 'without-x', 'Build without X11 support'
  option :cxx11

  depends_on 'pkg-config' => :build
  if build.cxx11?
    depends_on 'libsigc++' => 'c++11'
  else
    depends_on 'libsigc++'
  end

  depends_on 'cairo'
  depends_on 'libpng'
  depends_on :x11 if build.with? "x"

  def install
    ENV.cxx11 if build.cxx11?
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
