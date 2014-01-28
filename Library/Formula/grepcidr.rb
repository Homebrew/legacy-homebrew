require 'formula'

class Grepcidr < Formula
  homepage 'http://www.pc-tools.net/unix/grepcidr/'
  url 'http://www.pc-tools.net/files/unix/grepcidr-1.4.tar.gz'
  sha1 'fb8c8f271d22ddedd66626ec9b77da69f2ee447b'

  def install
    system "make"
    bin.install 'grepcidr'
  end
end
