require 'formula'

class Spim < Formula
  homepage 'http://pages.cs.wisc.edu/~larus/spim.html'
  url 'http://www.cs.wisc.edu/~larus/SPIM/spim.tar.gz'
  version '8.0'
  md5 '146558e8256f2b7577fb825fdc76a04f'

  def install
    cd 'spim' do
      inreplace "Makefile" do |s|
        s.change_make_var! "BIN_DIR", bin
        s.change_make_var! "EXCEPTION_DIR", libexec
        s.change_make_var! "MAN_DIR", man1
      end

      system "make"
      system "make install"
      system "make install-man"
      system "make test"

      mv "#{man1}/spim.man", "#{man1}/spim.1"
    end
  end
end
