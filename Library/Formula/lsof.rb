require 'formula'

class Lsof <Formula
  url 'ftp://lsof.itap.purdue.edu/pub/tools/unix/lsof/lsof.tar.bz2'
  version '4.82'
  md5 '5518a0c16fc937523b3d1a946cf59e5b'
  homepage 'http://people.freebsd.org/~abe/'

  def install
    system "tar xf lsof_4.82_src.tar"
    Dir.chdir "lsof_4.82_src" do
      mv "00README", "../README"
      system "./Configure -n darwin"
      system "make"
      bin.install "lsof"
    end
  end
end
