require 'formula'

class Zint < Formula
  url 'http://downloads.sourceforge.net/project/zint/zint/2.4.3/zint-2.4.3.tar.gz'
  homepage 'http://www.zint.org.uk'
  md5 '2b47caff88cb746f212d6a0497185358'
  head 'git://zint.git.sourceforge.net/gitroot/zint/zint'

  depends_on 'cmake' => :build

  def install
    mkdir 'zint-build'
    cd 'zint-build'
    system "cmake ..  #{std_cmake_parameters} -DCMAKE_PREFIX_PATH=#{prefix} -DCMAKE_C_FLAGS=-I/usr/X11/include"
    system "make install"
  end

  def test
    mktemp do
      system "#{bin}/zint -o test-zing.png -d 'This Text'"
      system "/usr/bin/open test-zing.png && sleep 3"
    end
  end
end
