require 'formula'

class Lsof < Formula
  url 'ftp://sunsite.ualberta.ca/pub/Mirror/lsof/lsof_4.85.tar.bz2'
  md5 '102ee2081172bbe76dccaa6cceda8573'
  homepage 'http://people.freebsd.org/~abe/'

  def install
    system "tar xf lsof_4.85_src.tar"
    Dir.chdir "lsof_4.85_src" do
      mv "00README", "../README"
      system "./Configure -n darwin"
      system "make"
      bin.install "lsof"
    end
  end
end
