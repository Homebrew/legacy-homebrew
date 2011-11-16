require 'formula'

class Bsponmpi < Formula
  url 'http://downloads.sourceforge.net/project/bsponmpi/bsponmpi/0.3/bsponmpi-0.3.tar.gz'
  homepage 'http://sourceforge.net/projects/bsponmpi'
  md5 '75db882a340ef5e97d8398db3e1611d0'

  depends_on 'scons'
  depends_on 'open-mpi'

  def install
    system "scons"
    system "cp lib/* #{HOMEBREW_PREFIX}/lib"
    system "cp -R include/* #{HOMEBREW_PREFIX}/include"
  end
end
