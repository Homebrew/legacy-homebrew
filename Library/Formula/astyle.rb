require 'formula'

class Astyle <Formula
  url 'http://downloads.sourceforge.net/sourceforge/astyle/astyle_2.01_macosx.tar.gz'
  md5 'f81408554bf93ea4ad4feb008a76202c'
  homepage 'http://astyle.sourceforge.net/'

  def install
    Dir.chdir 'src' do
      ENV['prefix']=prefix
      system "make -f ../build/mac/Makefile"
      bin.install "bin/astyle"
    end
  end
end
