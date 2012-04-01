require 'formula'

class Bsponmpi < Formula
  url 'http://downloads.sourceforge.net/project/bsponmpi/bsponmpi/0.3/bsponmpi-0.3.tar.gz'
  homepage 'http://sourceforge.net/projects/bsponmpi'
  md5 '75db882a340ef5e97d8398db3e1611d0'

  depends_on 'scons' => :build
  depends_on 'open-mpi'

  def install
    system "scons -Q mode=release"
    lib.install Dir['lib/*']
    include.install Dir['include/*']
  end
end
