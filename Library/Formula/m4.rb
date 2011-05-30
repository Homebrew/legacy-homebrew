require 'formula'

class M4 < Formula
  url 'http://ftp.gnu.org/gnu/m4/m4-1.4.16.tar.gz'
  homepage 'http://www.gnu.org/software/m4'
  md5 'a5dfb4f2b7370e9d34293d23fd09b280'

  # depends_on 'cmake'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "ac_cv_libsigsegv=no",
                          "--prefix=#{prefix}"
    # system "cmake . #{std_cmake_parameters}"
    system "make"
    system "make install"
  end
end
