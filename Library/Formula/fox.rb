require "formula"

class Fox < Formula
  homepage "http://www.fox-toolkit.org/"
  url "ftp://ftp.fox-toolkit.org/pub/fox-1.6.49.tar.gz"
  sha1 "056a55ba7b4404af61d4256eafdf8fd0503c6fea"

  # Development and stable branches are incompatible
  devel do
    url "ftp://ftp.fox-toolkit.org/pub/fox-1.7.49.tar.gz"
    sha1 "a787a1300ddaf0330bb6ba656deda248d6e44f7a"
  end

  depends_on :x11
  depends_on "freetype"
  depends_on "libpng"
  depends_on "jpeg"
  depends_on "libtiff"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--enable-release",
                          "--prefix=#{prefix}",
                          "--with-x",
                          "--with-opengl"
    # Unset LDFLAGS, "-s" causes the linker to crash
    system "make", "install", "LDFLAGS="
    rm bin/"Adie.stx"
  end
end
