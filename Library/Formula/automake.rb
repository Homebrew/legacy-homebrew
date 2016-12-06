require 'formula'

class Automake < Formula
  url 'http://ftp.gnu.org/gnu/automake/automake-1.11.1.tar.gz'
  homepage 'http://www.gnu.org/software/automake'
  md5 '4ee7f0ff5f0e467d58b6bd5da96b1c74'

  # depends_on 'cmake'
  depends_on 'autoconf'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    # system "cmake . #{std_cmake_parameters}"
    system "make"
    system "make install"
  end
end
