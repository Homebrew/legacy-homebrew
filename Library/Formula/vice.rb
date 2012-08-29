require 'formula'

class Vice < Formula
  url "http://www.zimmers.net/anonftp/pub/cbm/crossplatform/emulators/VICE/vice-2.3.tar.gz"
  md5 "b48d137874daad50c087a0686cbdde34"
  homepage 'http://vice-emu.sourceforge.net/'

  depends_on 'jpeg'
  depends_on :libpng

  def remove_unused_icons
    Pathname.glob libexec+'*.app' do |d|
      appname = File.basename(d, '.app')

      Pathname.glob d+'Contents/Resources/x*.icns' do |g|
        File.unlink g if File.basename(g, '.icns') != appname
      end
    end
  end

  fails_with :llvm do
    build 2335
  end

  def install
    # Use Cocoa instead of X
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--with-cocoa",
                          "--without-x"
    system "make"
    system "make bindist"
    prefix.install Dir['vice-macosx-*/*']
    remove_unused_icons
  end

  def caveats
    "Cocoa apps for these emulators have been installed to #{prefix}."
  end
end
