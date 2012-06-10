require 'formula'

class Zint < Formula
  homepage 'http://zint.github.com/'
  url 'https://github.com/downloads/zint/zint/zint-2.4.3.tar.gz'
  md5 '2b47caff88cb746f212d6a0497185358'

  head 'git://zint.git.sourceforge.net/gitroot/zint/zint'

  depends_on 'cmake' => :build

  def install
    mkdir 'zint-build' do
      system "cmake", "..",
                      "-DCMAKE_PREFIX_PATH=#{prefix}",
                      "-DCMAKE_C_FLAGS=-I/usr/X11/include",
                      *std_cmake_args
      system "make install"
    end
  end

  def test
    mktemp do
      system "#{bin}/zint", "-o", "test-zing.png", "-d", "This Text"
      system "/usr/bin/qlmanage", "-p", "test-zing.png"
    end
  end
end
