require 'formula'

class Astyle < Formula
  homepage 'http://astyle.sourceforge.net/'
  url 'https://downloads.sourceforge.net/project/astyle/astyle/astyle%202.04/astyle_2.04_macosx.tar.gz'
  sha1 '2aa956c4521a1163da6a8be741786fd89c1f39a7'

  def install
    cd 'src' do
      system "make", "CXX=#{ENV.cxx}", "-f", "../build/mac/Makefile"
      bin.install "bin/astyle"
    end
  end
end
