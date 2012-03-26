require 'formula'

class Libcsv < Formula
  homepage 'http://sourceforge.net/projects/libcsv/'
  url 'http://downloads.sourceforge.net/project/libcsv/libcsv/libcsv-3.0.1/libcsv-3.0.1.tar.gz'
  md5 '926b55d732b775a49ed2539c4db5c102'

  def install
    include.mkpath
    lib.mkpath
    man.mkpath

    system "make", "CC=#{ENV.cc}",
                   "INCDIR=#{include}",
                   "LIBDIR=#{lib}",
                   "MANDIR=#{man}",
                   "install"
  end
end
