require 'formula'

class FdkAac < Formula
  homepage 'http://sourceforge.net/projects/opencore-amr/'
  url 'https://downloads.sourceforge.net/project/opencore-amr/fdk-aac/fdk-aac-0.1.3.tar.gz'
  sha1 'fda64beee7f3b8e04ca209efcf9354cdae9afc33'

  head 'git://opencore-amr.git.sourceforge.net/gitroot/opencore-amr/fdk-aac'

  depends_on :autoconf
  depends_on :automake
  depends_on :libtool

  def install
    system "autoreconf -fvi"
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--disable-shared"
    system "make install"
  end
end
