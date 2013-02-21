require 'formula'

class Ficy < Formula
  homepage 'http://www.thregr.org/~wavexx/software/fIcy/'
  url 'http://www.thregr.org/~wavexx/software/fIcy/releases/fIcy-1.0.18.tar.gz'
  sha1 '326d1b5417e9507974df94d227c7e7e476b7598f'

  depends_on 'cmake' => :build

  def install
    system "make"
    prefix.install 'fIcy', 'fPls', 'fResync'
  end

  def test
    system "fIcy"
    system "fPls"
    system "fResync"
  end
end
