require 'formula'

class Treefrog < Formula
  homepage 'http://www.treefrogframework.org'
  url 'http://downloads.sourceforge.net/project/treefrog/src/treefrog-0.84.tar.gz'
  sha1 '287ff031a072bbba54bbdb46bcd4d7725591c86f'

  depends_on 'qt'

  def install
    system "./configure", "--framework=#{lib}", "--bindir=#{bin}", "--datadir=#{share}"
    Dir.chdir("src")
    system "make"
    system "make install"
    Dir.chdir("../tools")
    system "make"
    system "make install"
    system "install_name_tool -change treefrog.framework/Versions/0/treefrog #{lib}/treefrog.framework/Versions/0/treefrog #{bin}/treefrog"
    system "install_name_tool -change treefrog.framework/Versions/0/treefrog #{lib}/treefrog.framework/Versions/0/treefrog #{bin}/tadpole"
  end

  def test
    system "tspawn"
  end
end
