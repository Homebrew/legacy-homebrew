require 'formula'

class Samba < Formula
  url 'http://samba.org/samba/ftp/stable/samba-3.6.0.tar.gz'
  homepage 'http://samba.org/'
  md5 'e297e0ea7923c7de8d7c1d8fd0ec0a05'

  # depends_on 'cmake'

  def install
    Dir.chdir('source3') do
      system "./autogen.sh"
      system "./configure", "--disable-debug", "--disable-dependency-tracking",
                            "--prefix=#{prefix}"
      # system "cmake . #{std_cmake_parameters}"
      system "make install"
      system "touch #{prefix}/lib/smb.conf"
    end
  end
end
