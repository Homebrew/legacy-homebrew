require 'formula'

class FileMagic < Formula
  url 'ftp://ftp.astron.com/pub/file/file-5.08.tar.gz'
  homepage 'http://www.darwinsys.com/file/'
  md5 '6a2a263c20278f01fe3bb0f720b27d4e'

  # depends_on 'cmake'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    # system "cmake . #{std_cmake_parameters}"
    system "make install"
  end

  #def test
    # this will fail we won't accept that, make it test the program works!
    #system "/usr/bin/false"
  #end
end
