require 'formula'

class Madplay < Formula
  homepage 'http://www.underbit.com/products/mad/'
  url 'https://downloads.sourceforge.net/project/mad/madplay/0.15.2b/madplay-0.15.2b.tar.gz'
  sha1 '29105eb27c1416aa33c8d1ab3404a8e5f0aecd3f'

  depends_on 'mad'
  depends_on 'libid3tag'

  patch :p0 do
    url "https://trac.macports.org/export/89276/trunk/dports/audio/madplay/files/patch-audio_carbon.c"
    sha1 "bfad8010e755f3bf3f51884aceaa69b1deb3f940"
  end

  def install
    args = ["--disable-debug", "--disable-dependency-tracking",
            "--prefix=#{prefix}",
            "--mandir=#{man}"]
    # Avoid "error: CPU you selected does not support x86-64 instruction set"
    args << "--build=#{Hardware::CPU.arch_64_bit}" if MacOS.prefer_64_bit?
    system "./configure", *args
    system "make install"
  end
end
