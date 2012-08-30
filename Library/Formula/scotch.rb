require 'formula'

class Scotch < Formula
  homepage 'https://gforge.inria.fr/projects/scotch'
  url 'https://gforge.inria.fr/frs/download.php/28933'
  version '5.1.12'
  md5 'f873ff2bad519f9be7bc7b117bbe0bc4'

  depends_on MPIDependency.new(:cc)

  def install
    cd 'src' do
      ln_s 'Make.inc/Makefile.inc.i686_mac_darwin8', 'Makefile.inc'

      # Use mpicc to compile everything
      inreplace 'Makefile.inc' do |s|
        s.change_make_var! 'CCS', ENV['MPICC']
        s.change_make_var! 'CCP', ENV['MPICC']
        s.change_make_var! 'CCD', ENV['MPICC']
      end

      system 'make', 'scotch'
      system 'make', 'ptscotch'
      system 'make', 'install', "prefix=#{prefix}"
    end
  end
end
