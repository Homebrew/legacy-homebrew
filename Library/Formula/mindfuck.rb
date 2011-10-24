require 'formula'

class Mindfuck < Formula
  url 'https://github.com/garretraziel/mindfuck.git', :using => :git
  homepage 'https://github.com/garretraziel/mindfuck'
  md5 'f3876f8af35af88a4a61a1eab57bc528'
  version '0.1'
  
  def install
    bin.install 'mindfuck.py' => 'mindfuck'
    bin.install ['pyfuk.py', 'pyfuk.pyc']
    chmod 0755, bin+'mindfuck'
  end
  
  def test
    system "mindfuck"
  end
end
