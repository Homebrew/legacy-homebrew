require 'formula'

class Swaks < Formula
  url 'http://jetmore.org/john/code/swaks/swaks-20120320.0.tar.gz'
  homepage 'http://www.jetmore.org/john/code/swaks/'
  md5 '1c0b8cfc92aa4a36f3136c15d4f87e9b'

  def install
    bin.install('swaks')
  end
end
