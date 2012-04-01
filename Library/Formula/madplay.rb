require 'formula'

class Madplay < Formula
  homepage 'http://www.underbit.com/products/mad/'
  url 'http://downloads.sourceforge.net/project/mad/madplay/0.15.2b/madplay-0.15.2b.tar.gz'
  md5 '6814b47ceaa99880c754c5195aa1aac1'

  depends_on 'mad'
  depends_on 'libid3tag'

  def patches
    {:p0 => "https://trac.macports.org/export/89276/trunk/dports/audio/madplay/files/patch-audio_carbon.c"}
  end

  def install
    args = ["--disable-debug", "--disable-dependency-tracking",
            "--prefix=#{prefix}",
            "--mandir=#{man}"]
    # Avoid "error: CPU you selected does not support x86-64 instruction set"
    args << "--build=x86_64" if MacOS.prefer_64_bit?
    system "./configure", *args
    system "make install"
  end
end
