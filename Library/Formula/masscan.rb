require 'formula'

class Masscan < Formula
  homepage 'https://github.com/robertdavidgraham/masscan'
  url 'https://github.com/robertdavidgraham/masscan/archive/v2.tar.gz'
  sha1 '72a678aa88fcd76de91560d702f524bc8c0ceaae'

  def install
    system "make"
    bin.install 'bin/masscan'
  end

  test do
    # since the main purpose of masscan requires sudo, we'll test
    # that the help shows
    output = %x( #{bin}/masscan --help )
    if !output.include? "MASSCAN is a fast port scanner"
      false
    end
  end
end
