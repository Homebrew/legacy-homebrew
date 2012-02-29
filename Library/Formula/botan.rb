require 'formula'

class Botan < Formula
  homepage 'http://botan.randombit.net/'
  url 'http://files.randombit.net/botan/v1.10/Botan-1.10.1.tbz'
  md5 '7ae93e205491a8e75115bfca983ff7f9'

  def options
    [['--enable-debug', "Enable debug build of Botan"]]
  end

  def install
    args = ["--prefix=#{prefix}"]
    args << "--cpu=x86_64" if MacOS.prefer_64_bit?
    args << "--enable-debug" if ARGV.include? "--enable-debug"

    system "./configure.py", *args
    system "make install"
  end
end
