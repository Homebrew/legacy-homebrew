require 'formula'

class Samba <Formula
  url 'http://www.samba.org/samba/ftp/stable/samba-3.5.4.tar.gz'
  homepage ''
  md5 ''

# depends_on 'cmake'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking", "--prefix=#{prefix}"
#   system "cmake . #{std_cmake_parameters}"
    system "make install"
  end
end
