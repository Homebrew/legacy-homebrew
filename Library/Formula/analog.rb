require 'formula'

# Jason Thaxter <jason@thaxter.net>

class Analog < Formula
  homepage 'http://analog.cx'
  url 'http://analog.cx/analog-6.0.tar.gz'
  md5 '743d03a16eb8c8488205ae63cdb671cd'

  depends_on 'gd'
  depends_on 'jpeg'
  depends_on 'libpng'

  def install
    system "make DEFS='-DLANGDIR=\\\"/usr/local/share/analog/lang/\\\"'"
    system "mkdir -p /usr/local/Cellar/analog/6.0/bin"
    system "mkdir -p /usr/local/Cellar/analog/6.0/share/analog/lang"
    system "mkdir -p /usr/local/Cellar/analog/6.0/share/man"
    system "mkdir -p /usr/local/Cellar/analog/6.0/share/man/man1"
    system "mkdir -p /usr/local/Cellar/analog/6.0/etc"
    system "mkdir -p /usr/local/Cellar/analog/6.0/share/analog"
    system "cp analog /usr/local/Cellar/analog/6.0/bin"
    system "cp -R examples how-to images lang /usr/local/Cellar/analog/6.0/share/analog/"
    system "cp analog.man /usr/local/Cellar/analog/6.0/share/man/man1/analog.1"
    system "cp analog.cfg /usr/local/Cellar/analog/6.0/etc/analog.cfg-dist"
  end

  def test
    system "/usr/local/bin/analog"
  end
end
