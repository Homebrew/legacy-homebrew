require 'formula'

class Objconv < Formula
  homepage 'https://github.com/vertis/objconv'
  url 'https://github.com/vertis/objconv/archive/ee1cef289b8b29304462ff77f69c46b909a51c40.zip'
  version '2.12'
  sha1 '5098afaed635e7c081c2aeeda5e666c9990637f2'

  def install
    system "#{ENV.cxx} -o objconv -O2 src/*.cpp"
    bin.install 'objconv'
  end
end
