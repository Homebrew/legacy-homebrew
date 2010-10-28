require 'formula'
require 'hardware'

class Sbcl <Formula
  if snow_leopard_64?
    url 'http://homepage.mac.com/jafingerhut/files/sbcl/sbcl-1.0.42-x86-64-darwin-binary.tar.bz2'
    md5 'c203b1c9f51d8984edbc85cee956ce16'
  else
    url 'http://homepage.mac.com/jafingerhut/files/sbcl/sbcl-1.0.42-x86-darwin-binary.tar.bz2'
    md5 'b8868d668ea6e636c1f153471e4dd24f'
  end
  version '1.0.42'
  homepage 'http://www.sbcl.org/'

  skip_clean 'bin'
  skip_clean 'lib'

  def install
    ENV['INSTALL_ROOT'] = prefix
    system "sh install.sh"
  end
end
