require 'formula'

class Astyle < Formula
  homepage 'http://astyle.sourceforge.net/'
  url 'http://downloads.sourceforge.net/sourceforge/astyle/astyle_2.02.1_macosx.tar.gz'
  md5 '38f3a20be7ba685496d479316d6004b0'

  def install
    cd 'src' do
      system "make", "CXX=#{ENV.cxx}", "-f", "../build/mac/Makefile"
      bin.install "bin/astyle"
    end
  end
end
