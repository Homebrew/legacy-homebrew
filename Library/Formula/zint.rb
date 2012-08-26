require 'formula'

class Zint < Formula
  homepage 'http://zint.github.com/'
  url 'https://github.com/downloads/zint/zint/zint-2.4.3.tar.gz'
  sha1 '300732d03c77ccf1031c485a20f09b51495ef5a3'

  head 'git://zint.git.sourceforge.net/gitroot/zint/zint'

  option 'qt', 'Build the zint-qt GUI.'

  depends_on 'cmake' => :build
  depends_on :x11
  depends_on 'qt' => :optional if build.include? 'qt'

  def install
    mkdir 'zint-build' do
<<<<<<< HEAD
      system "cmake", "..",
                      "-DCMAKE_PREFIX_PATH=#{prefix}",
                      "-DCMAKE_C_FLAGS=-I#{MacOS::XQuartz.include}",
                      *std_cmake_args
=======
      system "cmake", "..", *std_cmake_args
>>>>>>> 0dba76a6beda38e9e5357faaf3339408dcea0879
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
