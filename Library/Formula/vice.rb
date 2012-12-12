require 'formula'

class Vice < Formula
  homepage 'http://vice-emu.sourceforge.net/'
  url "http://www.zimmers.net/anonftp/pub/cbm/crossplatform/emulators/VICE/vice-2.3.tar.gz"
  sha1 '5e7e1a375a4ca8c4895dc1552162955fdffce296'

  depends_on 'pkg-config' => :build
  depends_on 'jpeg'
  depends_on :libpng
  depends_on 'giflib' => :optional
  depends_on 'lame' => :optional

  fails_with :llvm do
    build 2335
  end

  def install
    # Use Cocoa instead of X
    # Use a static lame, otherwise Vice is hard-coded to look in
    # /opt for the library.
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--with-cocoa",
                          "--without-x",
                          "--enable-static-lame"
    system "make"
    system "make bindist"
    prefix.install Dir['vice-macosx-*/*']
  end

  def caveats
    "Cocoa apps for these emulators have been installed to #{prefix}."
  end
end
