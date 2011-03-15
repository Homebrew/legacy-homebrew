require 'formula'

class Zint < Formula
  url 'http://downloads.sourceforge.net/project/zint/zint/2.4.1/zint-2.4.1.tar.gz'
  homepage 'http://www.zint.org.uk'
  md5 '7ec4441907827fa613b11847a467c61d'
  head 'git://zint.git.sourceforge.net/gitroot/zint/zint'

  depends_on 'cmake'

  def install
    cd('build')
    system "cmake ..  #{std_cmake_parameters} -DCMAKE_PREFIX_PATH=#{prefix} -DCMAKE_C_FLAGS=-I/usr/X11R6/include"
    system "make install"
  end

  def test
    system "zint -o test-zing.png -d 'This Text'"
    system "open test-zing.png"
    puts "You may want to `rm test-zing.png`"
  end
end
