# m4-1.4.16
# rhubarb@ruction.org

require 'formula'

class M4 < Formula
  url 'http://ftp.gnu.org/gnu/m4/m4-1.4.16.tar.gz'
  homepage ''
  md5 'a5dfb4f2b7370e9d34293d23fd09b280'

  # depends_on 'cmake'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    # system "cmake . #{std_cmake_parameters}"
    system "make install"
  end
end
