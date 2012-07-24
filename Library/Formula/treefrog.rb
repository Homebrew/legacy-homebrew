require 'formula'

class Treefrog < Formula
  homepage 'http://www.treefrogframework.org'
  url 'http://downloads.sourceforge.net/project/treefrog/src/treefrog-1.0.tar.gz'
  sha1 'a231e2480856c20fc6efb5bfc2f37d751767ab8e'

  depends_on 'qt'

  def install
    system "./configure", "--framework=#{lib}", "--bindir=#{bin}", "--datadir=#{share}"
    cd 'src' do
      system "make"
      system "make install"
    end
    cd 'tools' do
      system "make"
      system "make install"
      system "install_name_tool", "-change", "treefrog.framework/Versions/1/treefrog", "#{lib}/treefrog.framework/Versions/1/treefrog", "#{bin}/treefrog"
      system "install_name_tool", "-change", "treefrog.framework/Versions/1/treefrog", "#{lib}/treefrog.framework/Versions/1/treefrog", "#{bin}/tadpole"
    end

  end

  def test
    system "tspawn"
  end
end
