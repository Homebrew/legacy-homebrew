require 'brewkit'

class Astyle <Formula
  @url='http://kent.dl.sourceforge.net/sourceforge/astyle/astyle_1.23_macosx.tar.gz'
  @md5='9f7f3237996776d01bc6837cd445a442'
  @homepage='http://astyle.sourceforge.net/'

  def install
    Dir.chdir 'src' do
      ENV['prefix']=prefix
      system "make -f ../buildmac/Makefile"
      bin.install "../bin/astyle"
    end
  end
end
