require 'formula'

# "File" is a reserved class name - set as an alias
class FileKeg < Formula
  url 'ftp://ftp.astron.com/pub/file/file-5.08.tar.gz'
  homepage 'http://www.darwinsys.com/file/'
  md5 '6a2a263c20278f01fe3bb0f720b27d4e'
  head 'git://github.com/glensc/file.git'

  keg_only :provided_by_osx, <<-EOS.undent
    As of Lion 10.7 the newest version of file is 5.04. Improvements have
    been made since.
  EOS

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
