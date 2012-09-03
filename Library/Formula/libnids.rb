require 'formula'

class Libnids < Formula
  homepage 'http://libnids.sourceforge.net/'
  url 'http://downloads.sourceforge.net/project/libnids/libnids/1.24/libnids-1.24.tar.gz'
  md5 '72d37c79c85615ffe158aa524d649610'

  option "disable-libnet", "Don't include code requiring libnet"
  option "disable-libglib", "Don't use glib2 for multiprocessing support"

  depends_on 'pkg-config' => :build
  depends_on 'libnet' => :recommended unless build.include? "disable-libnet"
  depends_on 'glib' => :recommended unless build.include? "disable-libglib"

  def install
    args = ["--prefix=#{prefix}", "--mandir=#{man}"]
    args << "--disable-libnet" if build.include? "disable-libnet"
    args << "--disable-libglib" if build.include? "disable-libglib"

    system "./configure", *args
    system "make install"
  end
end
