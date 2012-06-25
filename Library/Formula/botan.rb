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
    # The --cc option needs "clang" or "gcc" and not the full path.
    args << "--cc=#{ENV.compiler.to_s}"

    system "./configure.py", *args
    # "-soname" can lead to issues like https://github.com/mxcl/homebrew/issues/11972
    inreplace "Makefile", "-Wl,-soname", "-dynamiclib -install_name "
    # A hack to force them use our CFLAGS. MACH_OPT is empty in the Makefile
    # but used for each call to cc/ld.
    system "make", "install", "MACH_OPT=#{ENV.cflags}"
  end
end
