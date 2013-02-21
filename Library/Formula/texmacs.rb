require 'formula'

class Texmacs < Formula
  homepage 'http://www.texmacs.org'
  url 'http://www.texmacs.org/Download/ftp/tmftp/source/TeXmacs-1.0.7.16-src.tar.gz'
  sha1 'bd73a8ff1c5361161cc65c57dfe8e706a1859231'

  depends_on "qt"
  depends_on "guile"
  depends_on "ghostscript"
  depends_on "imagemagick"
  depends_on :x11

  def install
    system "./configure", "--disable-debug",
                          "--prefix=#{prefix}"
    system "make"
    system "make install"
  end

  def caveats; <<-EOS.undent
      TeXmacs has been installed! You can also check some dependencies :
       * Aspell for spell checking
       * Gnuplot for inline plotting
       * ...and a lot more!

      Usually, TeXmacs detects the dependencies at runtime, so you can install
      them at any time.  If you encounter any problems and are upgrading from a
      previous version of TeXmacs, you can try to remove the ~/.TeXmacs folder.
    EOS
  end
end
