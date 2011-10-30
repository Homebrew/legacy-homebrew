require 'formula'

class Pdkim < Formula
  head 'https://github.com/duncanthrax/pdkim.git'
  homepage 'http://duncanthrax.net/pdkim/'

  def install
    inreplace 'Makefile.mac' do |s|
      s.change_make_var! 'PREFIX', prefix

      # Do not build for PowerPC
      s.gsub! '-arch ppc ', ''
    end

    lib.mkpath
    include.mkpath
    system "make -f Makefile.mac install"
  end
end
