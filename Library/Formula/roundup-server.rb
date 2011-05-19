require 'formula'

class RoundupServer <Formula
  url 'roundup-server'
  homepage ''
  md5 ''

  # depends_on 'cmake'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    # system "cmake . #{std_cmake_parameters}"
    system "make install"
  end
end
