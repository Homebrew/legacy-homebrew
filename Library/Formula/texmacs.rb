require "formula"

class Texmacs < Formula
  homepage "http://www.texmacs.org"
  head "svn://svn.savannah.gnu.org/texmacs/trunk/src"
  url "http://www.texmacs.org/Download/ftp/tmftp/source/TeXmacs-1.99.1-src.tar.gz"
  sha1 "a5c7171644c84866445334b2d0cb39a6d9dd5f54"

  depends_on "qt"
  depends_on "guile"
  depends_on "ghostscript"
  depends_on "imagemagick"
  depends_on :x11

  # Fails with clang and gcc4.8 due to out-of-spec C++.
  # Success with --cc=gcc-4.2

  def install
    system "./configure", "--disable-debug",
                          "--prefix=#{prefix}",
                          "--enable-guile2=yes"
    system "make"
    system "make", "install"
  end
end
