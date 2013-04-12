require 'formula'

class Wry < Formula
  homepage 'http://grailbox.com/wry/'
  url 'http://grailbox.com/wry/wry_1.2.zip'
  sha1 'ee75e658e37180285876d62bbe8c1618bff013a8'

  def install
    bin.install('wry')
  end

  test do
    system "wry"
  end
end
