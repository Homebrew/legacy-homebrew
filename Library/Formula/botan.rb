require 'formula'

class Botan < Formula
  homepage 'http://botan.randombit.net/'
  url 'http://botan.randombit.net/files/Botan-1.10.5.tbz'
  sha1 '998b25d78e139b9c9402919aec4daa1c6118f2fb'

  option 'enable-debug', 'Enable debug build of Botan'

  def install
    args = ["--prefix=#{prefix}"]
    args << "--cpu=x86_64" if MacOS.prefer_64_bit?
    args << "--enable-debug" if build.include? "enable-debug"
    args << "--cc=#{ENV.compiler}"

    system "./configure.py", *args
    # A hack to force them use our CFLAGS. MACH_OPT is empty in the Makefile
    # but used for each call to cc/ld.
    system "make", "install", "MACH_OPT=#{ENV.cflags}"
  end
end
