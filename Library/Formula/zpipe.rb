require 'formula'

class Zpipe < Formula
  homepage 'http://www.zlib.net/'
  url 'http://www.zlib.net/zpipe.c'
  sha1 'b59f2d5676cc135ac0af040d90c3e7b366fcce93'
  version '1.4'

  def install
    system ENV.cc, '-o', 'zpipe', '-lz', 'zpipe.c'
    bin.install 'zpipe'
  end

  test do
    system 'zpipe --help 2>&1 | grep "zpipe usage"'
  end
end

