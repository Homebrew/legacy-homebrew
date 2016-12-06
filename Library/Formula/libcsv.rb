require 'formula'

class Libcsv < Formula
  url 'http://downloads.sourceforge.net/project/libcsv/libcsv/libcsv-3.0.1/libcsv-3.0.1.tar.gz'
  homepage 'http://sourceforge.net/projects/libcsv/'
  md5 '926b55d732b775a49ed2539c4db5c102'

  def install
    inreplace 'Makefile' do |s|
      s.change_make_var! "INCDIR", include
      s.change_make_var! "MANDIR", man
      s.change_make_var! "LIBDIR", lib
    end
    man.mkpath
    lib.mkpath
    include.mkpath
    system "make"
    system "make install"
  end
end
