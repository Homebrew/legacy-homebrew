require 'formula'

class Rdio < Formula
  homepage 'http://obihann.github.io/RdioCommander/'
  url 'https://github.com/obihann/RdioCommander/archive/1.0.tar.gz'
  sha1 '67317d197f4ffbe538ca722fec6796bd46143a44'

  depends_on :python

  def install
    system "python", "setup.py", "install", "--home=#{prefix}"
  end

  def test
    system "#{bin}/rdio"
  end
end
