require 'formula'

class Htmldoc < Formula
  homepage "http://www.msweet.org/projects.php?Z1"
  url "http://www.msweet.org/files/project1/htmldoc-1.8.28-source.tar.bz2"
  sha1 "44ac8b5f116383e9ae44bb1fd7d8caf6e3edf9c2"
  revision 1

  depends_on "libpng"
  depends_on "jpeg"

  def install
    system "./configure", "--disable-debug",
                          "--prefix=#{prefix}",
                          "--mandir=#{man}"
    system "make"
    system "make", "install"
  end
end
