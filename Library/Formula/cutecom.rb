require 'formula'

class Cutecom < Formula
  url 'http://cutecom.sourceforge.net/cutecom-0.22.0.tar.gz'
  homepage 'http://cutecom.sf.net'
  md5 'dd85ceecf5a60b4d9e4b21a338920561'

  depends_on 'cmake' => :build
  depends_on 'qt'

  def install
    system "cmake . #{std_cmake_parameters}"
    system "make install"
  end

  def test
    system "test -x /Applications/CuteCom.app/Contents/MacOS/CuteCom"
  end
end
