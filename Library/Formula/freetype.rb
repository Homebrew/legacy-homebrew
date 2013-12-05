require 'formula'

class Freetype < Formula
  homepage 'http://www.freetype.org'
  url 'http://downloads.sf.net/project/freetype/freetype2/2.5.1/freetype-2.5.1.tar.bz2'
  sha1 '38f561bf3eaa3627015503cb736e137da2fafc6c'

  bottle do
    cellar :any
    revision 1
    sha1 '4110fc47a6c0194dafd710e0dcea1ef2dfb85790' => :mavericks
    sha1 '5ba6cb8fe00857d72b481313623f9d929ad5f779' => :mountain_lion
    sha1 '4022a53d0c10b98944f4a907c8629faa81caf2cd' => :lion
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
