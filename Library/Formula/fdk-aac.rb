require 'formula'

class FdkAac < Formula
  homepage 'http://sourceforge.net/projects/opencore-amr/'
  url 'http://downloads.sourceforge.net/opencore-amr/fdk-aac-0.1.0.tar.gz'
  sha1 '4798377069f5f10e8b04e00a3d5a2d15bedfcb47'

  head 'git://opencore-amr.git.sourceforge.net/gitroot/opencore-amr/fdk-aac'

  depends_on :automake => :build
  depends_on :libtool => :build

  def install
    system "autoreconf -fvi"
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--disable-shared"
    system "make install"
  end
end
