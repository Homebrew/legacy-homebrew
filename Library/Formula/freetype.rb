require 'formula'

class Freetype < Formula
  homepage 'http://www.freetype.org'
  url 'https://downloads.sf.net/project/freetype/freetype2/2.5.3/freetype-2.5.3.tar.bz2'
  sha1 'd3c26cc17ec7fe6c36f4efc02ef92ab6aa3f4b46'
  revision 1

  bottle do
    cellar :any
    sha1 "8bd9ed39a4cdf44ddecc7a296bcd7ca0a3f85b4c" => :mavericks
    sha1 "a015c1d8d3436eff57c9368f353271aee776dbe4" => :mountain_lion
    sha1 "25375d5fdb01e73587584d4d7883f5e646280e54" => :lion
  end

  keg_only :provided_pre_mountain_lion

  option :universal

  depends_on "libpng"

  def install
    ENV.universal_binary if build.universal?
    system "./configure", "--prefix=#{prefix}", "--without-harfbuzz"
    system "make"
    system "make", "install"
  end

  test do
    system "#{bin}/freetype-config", '--cflags', '--libs', '--ftversion',
      '--exec-prefix', '--prefix'
  end
end
