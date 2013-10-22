require 'formula'

class FdkAac < Formula
  homepage 'http://sourceforge.net/projects/opencore-amr/'
  url 'http://downloads.sourceforge.net/project/opencore-amr/fdk-aac/fdk-aac-0.1.2.tar.gz'
  sha1 '09f7aa744d11ec21ee13c44645d3a3372c3ce6e4'

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
