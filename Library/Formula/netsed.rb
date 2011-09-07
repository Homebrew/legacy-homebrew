require 'formula'

class Netsed < Formula
  url 'http://packetstormsecurity.org/UNIX/misc/netsed.tgz'
  homepage 'http://www.securiteam.com/tools/5IP022A35W.html'
  version '0.01b'
  md5 '56f5d8af7d21dbb25a50e673442edc30'

  def install
    system "make"
    bin.install "netsed"
  end
end
