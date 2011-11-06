require 'formula'

class Cppcheck < Formula
  url 'http://downloads.sourceforge.net/project/cppcheck/cppcheck/1.50/cppcheck-1.50.tar.bz2'
  homepage 'http://sourceforge.net/apps/mediawiki/cppcheck/index.php?title=Main_Page'
  md5 '79ef3898b246ba9c143155d5ad23dbd1'
  head 'https://github.com/danmar/cppcheck.git'

  depends_on 'pcre'

  # Do not strip binaries, or else it fails to run.
  skip_clean :all

  def install
    # Pass to make variables.
    system "make"
    system "make", "DESTDIR=#{prefix}", "BIN=#{bin}", "install"
    # Man pages aren't installed, they require docbook schemas which I don't know how to install.
  end
end
