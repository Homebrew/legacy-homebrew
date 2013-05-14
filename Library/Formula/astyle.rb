require 'formula'

class Astyle < Formula
  homepage 'http://astyle.sourceforge.net/'
  url 'http://sourceforge.net/projects/astyle/files/astyle/astyle%202.03/astyle_2.03_macosx.tar.gz'
  sha1 '60595f6a4704e9c2b9cc6a24c3276695dc6288b2'

  def install
    cd 'src' do
      system "make", "CXX=#{ENV.cxx}", "-f", "../build/mac/Makefile"
      bin.install "bin/astyle"
    end
  end
end
