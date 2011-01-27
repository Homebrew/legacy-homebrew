require 'formula'

class Lsof <Formula
  url 'ftp://lsof.itap.purdue.edu/pub/tools/unix/lsof/lsof.tar.bz2'
  version '4.83'
  md5 '8f731a6251b8c0143d585df0d5ca779e'
  homepage 'http://people.freebsd.org/~abe/'

  def install
    system "tar xf lsof_4.83_src.tar"
    Dir.chdir "lsof_4.83_src" do
      mv "00README", "../README"
      system "./Configure -n darwin"
      system "make"
      bin.install "lsof"
    end
  end
end
