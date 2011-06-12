require 'formula'

class VoAacenc < Formula
  url 'http://sourceforge.net/projects/opencore-amr/files/vo-aacenc/vo-aacenc-0.1.1.tar.gz'
  homepage 'http://sourceforge.net/projects/opencore-amr/'
  md5 'b5724e89d8b33abe41bc57032e671019'

  # depends_on 'cmake'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    # system "cmake . #{std_cmake_parameters}"
    system "make install"
  end
end
