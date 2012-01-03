require 'formula'

class Libgpod < Formula
  url 'http://sourceforge.net/projects/gtkpod/files/libgpod/libgpod-0.8/libgpod-0.8.0.tar.gz'
  homepage 'http://gtkpod.org/wiki/Libgpod'
  md5 '6660f74cc53293dcc847407aa5f672ce'

  # depends_on 'cmake' => :build

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    # system "cmake . #{std_cmake_parameters}"
    system "make install"
  end

end
