require 'formula'

class Cairomm < Formula
  homepage 'http://cairographics.org/cairomm/'
  url 'http://cairographics.org/releases/cairomm-1.10.0.tar.gz'
  sha256 '068d96c43eae7b0a3d98648cbfc6fbd16acc385858e9ba6d37b5a47e4dba398f'
  revision 1

  bottle do
    revision 1
    sha1 "11d150d437921cd03ec810690db1e12bf952a7cf" => :yosemite
    sha1 "17435d1a18ecda653fa71097ba9620b46421aabf" => :mavericks
    sha1 "3247ebe37140dc109465dcfc7b5df6d948690091" => :mountain_lion
  end

  option :cxx11

  deprecated_option "without-x" => "without-x11"

  depends_on 'pkg-config' => :build
  if build.cxx11?
    depends_on 'libsigc++' => 'c++11'
  else
    depends_on 'libsigc++'
  end

  depends_on 'cairo'
  depends_on 'libpng'
  depends_on :x11 => :recommended

  def install
    ENV.cxx11 if build.cxx11?
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
