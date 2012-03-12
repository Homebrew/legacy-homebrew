require 'formula'

class Astyle < Formula
  homepage 'http://astyle.sourceforge.net/'
  url 'http://downloads.sourceforge.net/sourceforge/astyle/astyle_2.02_macosx.tar.gz'
  md5 '16192ba46ba5348f107c712d6482c15a'

  def install
    cd 'src' do
      system "make", "CXX=#{ENV.cxx}", "-f", "../build/mac/Makefile"
      bin.install "bin/astyle"
    end
  end
end
