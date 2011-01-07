require 'formula'

class Grepcidr <Formula
  url 'http://www.pc-tools.net/files/unix/grepcidr-1.3.tar.gz'
  homepage 'http://www.pc-tools.net/unix/grepcidr/'
  md5 '7ccade25ce9fe6d6a02348ba8e4cf4a3'

  def install
    system "make"
    bin.install 'grepcidr'
  end
end
