require 'formula'

class Spim <Formula
  url 'http://www.cs.wisc.edu/~larus/SPIM/spim.tar.gz'
  homepage 'http://pages.cs.wisc.edu/~larus/spim.html'
  md5 '146558e8256f2b7577fb825fdc76a04f'
  version '8.0'


  def install
    Dir.chdir 'spim'

    inreplace "Makefile" do |s|
      s.change_make_var! "BIN_DIR", "#{prefix}/bin"
      s.change_make_var! "EXCEPTION_DIR", "#{prefix}/lib"
      s.change_make_var! "MAN_DIR", "#{prefix}/share/man/man1"
    end

    system "make"
    system "make install"
    system "make install-man"
    system "make test"
    
    Dir.chdir "#{prefix}/share/man/man1"
    mv 'spim.man', 'spim.1'
    
  end
end
