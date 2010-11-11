require 'formula'

class Gle <Formula
  url 'http://downloads.sourceforge.net/glx/gle-graphics-4.2.3bf-src.tar.gz'
  version '4.2.3b'
  homepage 'http://glx.sourceforge.net/'
  md5 '5884a1cbf7a0fe5d3a18a235d10f64a8'

  depends_on 'jpeg' => :optional
  depends_on 'libpng' => :optional
  depends_on 'libtiff' => :optional

  def install
    ENV.libpng

    arch = Hardware.is_64_bit? ? "x86_64" : "i386"

    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--with-arch=#{arch}"

    inreplace 'Makefile' do |s|
      s.change_make_var! "MKDIR_P", "mkdir -p"
    end

    system "make"

    ENV.deparallelize
    system "make install"
  end
end
