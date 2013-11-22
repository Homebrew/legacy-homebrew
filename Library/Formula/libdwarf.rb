require 'formula'

class Libdwarf < Formula
  homepage 'http://www.prevanders.net/dwarf.html'
  url 'http://www.prevanders.net/libdwarf-20130729.tar.gz'
  sha1 '68e3cef6a8b1d0ad56f0a45128f64bb37b0b6340'

  keg_only 'Used as a dependency for other formulas'

  depends_on 'libelf'

  def install
    chdir 'libdwarf' do
      system "./configure", "--disable-debug",
                            "--disable-dependency-tracking",
                            "--prefix=#{prefix}"
      system "make"
      lib.install 'libdwarf.a'
      include.install 'dwarf.h', 'libdwarf.h'
      doc.install 'README', 'NEWS', 'COPYING', 'ChangeLog'
      doc.install Dir['*.pdf']
    end
  end
end
