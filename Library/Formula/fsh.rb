require 'formula'

class Fsh < Formula
  homepage 'http://www.lysator.liu.se/fsh/'
  url 'http://www.lysator.liu.se/fsh/fsh-1.2.tar.gz'
  md5 '74d7fc65044d1c9c27c6e9edbbde9c68'

  def install
    # FCNTL was deprecated and needs to be changed to fcntl
    inreplace 'fshcompat.py', 'FCNTL', 'fcntl'

    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--infodir=#{info}"
    system "make install"

    cd bin do
      inreplace ["fsh", "fshd", "in.fshd"],
          "#! /usr/local/bin/python", "#!/usr/bin/env python"
    end
  end
end
