require 'formula'

class Mono < Formula
  url 'http://download.mono-project.com/sources/mono/mono-2.10.3.tar.bz2'
  homepage 'http://www.mono-project.com/Release_Notes_Mono_2.10.3'
  md5 'dbe1be797bbdb5e59d8429ae2a22db07'

  def install
    args = ["--prefix=#{prefix}",
            "--with-glib=embedded",
            "--enable-nls=no"]

    args << "--host=x86_64-apple-darwin10" if MacOS.prefer_64_bit?

    system "./configure", *args
    system "make"
    system "make install"
  end
end
