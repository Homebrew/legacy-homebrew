require 'formula'

class Gplcver < Formula
  homepage 'http://gplcver.sourceforge.net/'
  url 'https://downloads.sourceforge.net/project/gplcver/gplcver/2.12a/gplcver-2.12a.src.tar.bz2'
  sha1 '946bb35b6279646c6e10c309922ed17deb2aca8a'

  def install
    inreplace 'src/makefile.osx' do |s|
      s.gsub! '-mcpu=powerpc', ''
      s.change_make_var! 'CFLAGS', "$(INCS) $(OPTFLGS) #{ENV.cflags}"
      s.change_make_var! 'LFLAGS', ''
    end

    system "make", "-C", "src", "-f", "makefile.osx"
    bin.install 'bin/cver'
  end
end
