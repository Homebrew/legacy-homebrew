require 'formula'

class Ficy < Formula
  homepage 'http://www.thregr.org/~wavexx/software/fIcy/'
  url 'http://www.thregr.org/~wavexx/software/fIcy/releases/fIcy-1.0.18.tar.gz'
  sha1 '326d1b5417e9507974df94d227c7e7e476b7598f'

  def install
    system "make"
    bin.install 'fIcy', 'fPls', 'fResync'
  end
end
