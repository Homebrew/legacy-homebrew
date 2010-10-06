require 'formula'

class Tcpdump <Formula
  url 'http://www.tcpdump.org/release/tcpdump-4.1.1.tar.gz'
  homepage 'http://www.tcpdump.org/'
  md5 'd0dd58bbd6cd36795e05c6f1f74420b0'

  # depends_on 'cmake'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    # system "cmake . #{std_cmake_parameters}"
    system "make install"
  end
end
