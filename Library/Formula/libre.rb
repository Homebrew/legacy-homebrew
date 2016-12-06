require 'formula'

class Libre < Formula
  homepage 'http://www.creytiv.com/re.html'
  url 'http://www.creytiv.com/pub/re-0.4.2.tar.gz'
  sha1 '7a6f7d4fe8679761a23b5ef1a29e30ce0c6b854f'

  def install
    system "make"
    system "make install"
  end

  def test
    File.exist?('/usr/local/lib/libre.dylib')
  end
end
