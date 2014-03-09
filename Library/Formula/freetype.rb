require 'formula'

class Freetype < Formula
  homepage 'http://www.freetype.org'
  url 'https://downloads.sf.net/project/freetype/freetype2/2.5.3/freetype-2.5.3.tar.bz2'
  sha1 'd3c26cc17ec7fe6c36f4efc02ef92ab6aa3f4b46'

  bottle do
    cellar :any
    sha1 "f6f9a0ac918a5ef32d9245d74aa63a329a016b34" => :mavericks
    sha1 "643f9ea163b59e13a00251a2b151a5ea110675dd" => :mountain_lion
    sha1 "09b3677ce3fe49f7dba549679470d6e3cadd2954" => :lion
  end

  keg_only :provided_pre_mountain_lion

  option :universal

  depends_on :libpng

  def install
    ENV.universal_binary if build.universal?
    system "./configure", "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end

  test do
    system "#{bin}/freetype-config", '--cflags', '--libs', '--ftversion',
      '--exec-prefix', '--prefix'
  end
end
