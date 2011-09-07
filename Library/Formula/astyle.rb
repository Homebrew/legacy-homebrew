require 'formula'

class Astyle < Formula
  url 'http://downloads.sourceforge.net/sourceforge/astyle/astyle_2.02_macosx.tar.gz'
  md5 '16192ba46ba5348f107c712d6482c15a'
  homepage 'http://astyle.sourceforge.net/'

  def install
    Dir.chdir 'src' do
      ENV['prefix']=prefix
      system "make -f ../build/mac/Makefile"
      bin.install "bin/astyle"
    end
  end
end
