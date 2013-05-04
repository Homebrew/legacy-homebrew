require 'formula'

class FdkAac < Formula
  homepage 'http://sourceforge.net/projects/opencore-amr/'
  url 'http://sourceforge.net/projects/opencore-amr/files/fdk-aac/fdk-aac-0.1.1.tar.gz'
  sha1 '84badb9ada86a4488c03d8485f8365b60934ea36'

  head 'git://opencore-amr.git.sourceforge.net/gitroot/opencore-amr/fdk-aac'

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
