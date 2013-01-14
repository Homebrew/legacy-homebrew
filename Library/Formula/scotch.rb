require 'formula'

class Scotch < Formula
  homepage 'https://gforge.inria.fr/projects/scotch'
  url 'https://gforge.inria.fr/frs/download.php/31831/scotch_6.0.0.tar.gz'
  sha1 'eb32d846bb14449245b08c81e740231f7883fea6'

  depends_on MPIDependency.new(:cc)

  def install
    cd 'src' do
      ln_s 'Make.inc/Makefile.inc.i686_mac_darwin8', 'Makefile.inc'

      # Scotch uses more recent POSIX standards than OSX supports
      inreplace 'Makefile.inc' do |s|
        s.change_make_var! 'CCS', ENV['CC']
        s.change_make_var! 'CCP', ENV['MPICC']
        s.change_make_var! 'CCD', ENV['MPICC']
        s.slice! "-DCOMMON_PTHREAD"
        s.slice! "-DSCOTCH_PTHREAD"
      end
      system 'make', 'scotch','VERBOSE=ON'
      system 'make', 'ptscotch','VERBOSE=ON'
      system 'make', 'install', "prefix=#{prefix}"
    end
  end
end
