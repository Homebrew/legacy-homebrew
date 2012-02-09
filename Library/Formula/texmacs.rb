require 'formula'

class Texmacs < Formula
  url 'http://www.texmacs.org/Download/ftp/tmftp/source/TeXmacs-1.0.7.14-src.tar.gz'
  homepage 'http://www.texmacs.org'
  md5 '70843d2dd22862a856789ff3166fae0d'

  depends_on "qt"
  depends_on "guile"
  depends_on "ghostscript"
  depends_on "imagemagick"

  def install
    ENV.x11

    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make"
    system "make install"
  end

  def caveats
    general_caveats = <<-EOS.undent
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
