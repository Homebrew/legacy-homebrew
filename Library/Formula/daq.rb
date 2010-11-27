require 'formula'

class Daq <Formula
  url 'http://www.snort.org/dl/snort-current/daq-0.3.tar.gz'
  homepage ''
  md5 '300c1b0441a6763de87eaa50f8de6587'

  # depends_on 'cmake'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    # system "cmake . #{std_cmake_parameters}"
    system "make install"
  end
end
