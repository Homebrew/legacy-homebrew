require 'formula'

class Astyle < Formula
  homepage 'http://astyle.sourceforge.net/'
  url 'http://downloads.sourceforge.net/sourceforge/astyle/astyle_2.02.1_macosx.tar.gz'
  sha1 'b8e3e79c7134a0e97a1948608e3b58201d3af3de'

  def install
    cd 'src' do
      system "make", "CXX=#{ENV.cxx}", "-f", "../build/mac/Makefile"
      bin.install "bin/astyle"
    end
  end
end
