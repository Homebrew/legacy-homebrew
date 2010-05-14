require 'formula'

class Flusspferd <Formula
  url 'http://flusspferd.org/downloads/flusspferd-0.9.tar.bz2'
  homepage 'http://flusspferd.org/'
  md5 '7688b2a939777b4b7be82898dea9b3d9'

  depends_on 'cmake'
  depends_on 'arabica'
  depends_on 'gmp'
  depends_on 'boost'
  depends_on 'spidermonkey'

  def install
    ENV.gcc_4_2
    system "cmake -H. -Bbuild #{std_cmake_parameters}"
    system "make install"
  end
end
