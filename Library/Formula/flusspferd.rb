require 'formula'

class Flusspferd <Formula
  url 'http://flusspferd.org/downloads/flusspferd-0.9.tar.bz2'
  homepage 'http://flusspferd.org/'
  md5 '7688b2a939777b4b7be82898dea9b3d9'

  depends_on 'cmake' => :build
  depends_on 'arabica'
  depends_on 'gmp'
  depends_on 'boost'
  depends_on 'spidermonkey'

  def install
    fails_with_llvm
    system "cmake -H. -Bbuild #{std_cmake_parameters}"
    system "make install"
  end
end
