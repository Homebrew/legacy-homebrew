require 'formula'

class Talloc < Formula
  homepage 'http://talloc.samba.org/'
  url 'http://www.samba.org/ftp/talloc/talloc-2.1.0.tar.gz'
  sha1 'd079597f3f02a7ca3716645728a8a46016a1dd7d'

  conflicts_with 'samba', :because => 'both install `include/talloc.h`'

  def install
    system "./configure", "--prefix=#{prefix}", "--disable-rpath", "--without-gettext"
    system "make install"
  end
end
