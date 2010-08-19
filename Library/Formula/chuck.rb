require 'formula'

class Chuck <Formula
  url 'http://chuck.cs.princeton.edu/release/files/chuck-1.2.1.3.tgz'
  homepage 'http://chuck.cs.princeton.edu/'
  md5 'ac8459b4067c2491fbdeb61d122a5985'

  def install
    system "make -C src/ osx-#{Hardware.cpu_type}"
    bin.install "src/chuck"
    (share+'chuck').install "examples/"
  end
end
