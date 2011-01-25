require 'formula'

class Astyle <Formula
  url 'http://downloads.sourceforge.net/project/astyle/astyle/astyle%202.01/astyle_2.01_macosx.tar.gz?r=http%3A%2F%2Fsourceforge.net%2Fprojects%2Fastyle%2Ffiles%2Fastyle%2Fastyle%25202.01%2F&ts=1295918029&use_mirror=softlayer', :using => CurlDownloadStrategy
  md5 'f81408554bf93ea4ad4feb008a76202c'
  homepage 'http://astyle.sourceforge.net/'
  version '2.01'

  def install
    Dir.chdir 'src' do
      ENV['prefix']=prefix
      system "make -f ../build/mac/Makefile"
      bin.install "bin/astyle"
    end
  end
end