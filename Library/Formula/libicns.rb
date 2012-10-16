require 'formula'

class Libicns < Formula
  homepage 'http://icns.sourceforge.net'
  url 'http://sourceforge.net/projects/icns/files/libicns-0.8.1.tar.gz'
  sha1 '6e8a27326dad93133b9575acfedb6fa7a7694bf2'
  head 'https://icns.svn.sourceforge.net/svnroot/icns'

  option 'with-jasper', 'Build with JasPer rather than OpenJPEG'

  depends_on 'libpng'
  depends_on 'openjpeg' unless build.include? 'with-jasper'
  depends_on 'jasper'       if build.include? 'with-jasper'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
    (share/name).install Dir['samples/test*']
  end

  def test
    mktemp do
      %w{ test1.icns test2.rsrc test3.bin }.each do |testfile|
        system "#{bin}/icns2png", '-l', "#{share}/#{name}/#{testfile}"
        system "#{bin}/icns2png", '-x', "#{share}/#{name}/#{testfile}"
      end
      # test converting back on #1 (only one that comes back bit-identical)
      system "#{bin}/png2icns", "test1.icns", "test1_128x128x32.png"
      system "cmp", "test1.icns", "#{share}/#{name}/test1.icns"
    end
  end
end
