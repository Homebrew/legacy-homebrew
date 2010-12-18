require 'formula'

class Astyle <Formula
  url 'http://downloads.sourceforge.net/sourceforge/astyle/astyle_1.24_macosx.tar.gz'
  md5 '9b63dadac58e867f14b3894befbdc9b3'
  homepage 'http://astyle.sourceforge.net/'

  def install
    Dir.chdir 'src' do
      ENV['prefix']=prefix
      system "make -f ../build/mac/Makefile"
      bin.install "bin/astyle"
    end
  end
end