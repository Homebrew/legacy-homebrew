require 'formula'

class Bandicoot < Formula
  homepage 'http://bandilab.org/'
  url 'http://bandilab.org/download/mac-os/i386/bandicoot-v5.tar.gz'
  md5 '288a40d776bdeda259d39c3eaa565264'

  def install
    bin.install 'bandicoot'
  end
end
