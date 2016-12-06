require 'formula'

class Zshdb < Formula
  homepage 'https://github.com/rocky/zshdb'
  url 'http://sourceforge.net/projects/bashdb/files/zshdb/0.08/zshdb-0.08.tar.bz2'
  version '0.08'
  sha1 '29f860d0130debe6a966ee1e12f2f3046c78897b'

  head 'https://github.com/rocky/zshdb.git'

  depends_on 'zsh'

  if build.head?
    depends_on :automake
  end

  def install
    system "autoreconf -f -i" if build.head?
    system "autoconf" if build.head?
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--with-zsh=#{HOMEBREW_PREFIX}/bin/zsh"
    system "make install"
  end
end
