require 'formula'

class Zint < Formula
  homepage 'http://zint.github.io/'
  url 'https://github.com/downloads/zint/zint/zint-2.4.3.tar.gz'
  sha1 '300732d03c77ccf1031c485a20f09b51495ef5a3'
  revision 1

  head 'git://zint.git.sourceforge.net/gitroot/zint/zint'

  option 'qt', 'Build the zint-qt GUI.'

  depends_on 'cmake' => :build
  depends_on 'libpng'
  depends_on 'qt' if build.include? 'qt'

  def install
    mkdir 'zint-build' do
      system "cmake", "..", *std_cmake_args
      system "make install"
    end
  end

  test do
    system "#{bin}/zint", "-o", "test-zing.png", "-d", "This Text"
  end
end
