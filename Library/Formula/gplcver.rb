require 'formula'

class Gplcver < Formula
  homepage 'http://gplcver.sourceforge.net/'
  url 'http://sourceforge.net/projects/gplcver/files/gplcver/2.12a/gplcver-2.12a.src.tar.bz2'
  md5 '857a15a9ebc8ef63ece01502509cbeb7'

  def install
    inreplace 'src/makefile.osx' do |s|
      s.gsub! '-mcpu=powerpc', ''
      s.change_make_var! 'CFLAGS', "$(INCS) $(OPTFLGS) #{ENV.cflags}"
    end

    cd 'src' do
      system "make -f makefile.osx"
    end
    bin.install 'bin/cver'
  end
end
