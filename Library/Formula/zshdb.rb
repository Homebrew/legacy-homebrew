require 'formula'

class Zshdb < Formula
  homepage 'https://github.com/rocky/zshdb'
  url 'https://downloads.sourceforge.net/project/bashdb/zshdb/0.08/zshdb-0.08.tar.bz2'
  sha1 '29f860d0130debe6a966ee1e12f2f3046c78897b'

  head do
    url 'https://github.com/rocky/zshdb.git'
    depends_on :autoconf
    depends_on :automake
  end

  depends_on 'zsh'

  def install
    if build.head?
      system "autoreconf", "-fvi"
      system "autoconf"
    end

    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--with-zsh=#{HOMEBREW_PREFIX}/bin/zsh"
    system "make install"
  end
end
