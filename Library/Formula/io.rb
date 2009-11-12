require 'formula'

class Io <Formula
  head 'git://github.com/stevedekorte/io.git'
  homepage 'http://iolanguage.com/'
  
  def install
    system "make vm"
    system "make"
    system "make install"
  end
end
