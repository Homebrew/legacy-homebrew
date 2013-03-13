require 'formula'

class Htmldoc < Formula
  homepage 'http://www.htmldoc.org'
  url 'http://ftp.easysw.com/pub/htmldoc/1.8.27/htmldoc-1.8.27-source.tar.bz2'
  sha1 '472908e0aafed1cedfbacd8ed3168734aebdec4b'

  # Fixes building with libpng-1.5, from upstream svn r1668 via Fedora
  # Remove at version 1.8.28. cf. https://github.com/mxcl/homebrew/issues/15915
  def patches
    { :p0 => 'http://pkgs.fedoraproject.org/cgit/htmldoc.git/plain/htmldoc-1.8.27-libpng15.patch?h=f18' }
  end

  def install
    ENV.append_to_cflags "-I#{HOMEBREW_PREFIX}/include"

    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--mandir=#{man}"
    system "make"
    system "make install"
  end
end
