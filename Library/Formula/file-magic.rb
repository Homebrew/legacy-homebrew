require 'formula'

class FileMagic <Formula
  url 'ftp://ftp.astron.com//pub/file//file-5.04.tar.gz';
  homepage 'http://www.darwinsys.com/file/';
  md5 'accade81ff1cc774904b47c72c8aeea0'

  def install
    system "./configure"
    system "make install"
  end
end


