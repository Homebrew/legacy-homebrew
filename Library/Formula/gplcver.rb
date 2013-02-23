require 'formula'

class Gplcver < Formula
  homepage 'http://gplcver.sourceforge.net/'
  url 'http://sourceforge.net/projects/gplcver/files/gplcver/2.12a/gplcver-2.12a.src.tar.bz2'
  sha1 '946bb35b6279646c6e10c309922ed17deb2aca8a'

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
