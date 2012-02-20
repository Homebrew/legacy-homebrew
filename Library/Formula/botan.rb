require 'formula'

class Botan < Formula
  url 'http://files.randombit.net/botan/v1.10/Botan-1.10.1.tbz'
  homepage 'http://botan.randombit.net/'
  md5 '7ae93e205491a8e75115bfca983ff7f9'

  def options
    [
        ['--enable-debug', "Enable debug build of Botan (handy for when you are developing against it yourself)"],
    ]
  end

  def install
    args = ["--prefix=#{prefix}"]
    args << "--cpu=x86_64" if MacOS.prefer_64_bit?

    if ARGV.include? "--enable-debug"
        args << "--enable-debug"
    end

    system "./configure.py", *args
    system "make install"
  end
end
