require 'formula'

class Swaks < Formula
  homepage 'http://www.jetmore.org/john/code/swaks/'
  url 'http://jetmore.org/john/code/swaks/swaks-20120320.0.tar.gz'
  sha1 '2a20ba10ac0f97761edc6d1d519773192486d74c'

  def install
    bin.install 'swaks'
  end
end
