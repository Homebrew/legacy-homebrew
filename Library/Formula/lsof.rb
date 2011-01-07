require 'formula'

class Lsof <Formula
  url 'ftp://sunsite.ualberta.ca/pub/Mirror/lsof/lsof_4.84.tar.bz2'
  version '4.84'
  md5 'a09326df500ef7e4550af546868338d6'
  homepage 'http://people.freebsd.org/~abe/'

  def install
    system "tar xf lsof_4.84_src.tar"
    Dir.chdir "lsof_4.84_src" do
      mv "00README", "../README"
      system "./Configure -n darwin"
      system "make"
      bin.install "lsof"
    end
  end
end
