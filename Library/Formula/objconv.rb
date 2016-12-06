require 'formula'

class Objconv < Formula
  homepage 'https://github.com/vertis/objconv'
  url 'https://github.com/vertis/objconv/archive/2.16.tar.gz'
  version '2.16'
  sha1 '1dba1ebb64933ca51f722631c8d1693e6283d071'

  def install
    system "#{ENV.cxx} -o objconv -O2 src/*.cpp"
    bin.install 'objconv'
  end
end
