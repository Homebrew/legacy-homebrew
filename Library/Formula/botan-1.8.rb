require 'formula'

class Botan18 < Formula
  homepage 'http://botan.randombit.net/'
  url 'http://files.randombit.net/botan/v1.8/Botan-1.8.13.tbz'
  md5 '26674282f146d187ba98c09a137368f5'

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
