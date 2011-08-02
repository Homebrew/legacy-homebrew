require 'formula'

class Fsh < Formula
  url 'http://www.lysator.liu.se/fsh/fsh-1.2.tar.gz'
  homepage 'http://www.lysator.liu.se/fsh/'
  md5 '74d7fc65044d1c9c27c6e9edbbde9c68'

  def install
    # FCNTL was deprecated and needs to be changed to fcntl
    system "find . -type f -exec sed -i \"\" 's/FCNTL/fcntl/g' {} \\;"

    system "./configure", "--prefix=#{prefix}", "--disable-debug", "--disable-dependency-tracking"
    system "make install"

    cd bin do
      inreplace ["fsh", "fshd", "in.fshd"],
          "#! /usr/local/bin/python", "#!/usr/bin/env python"
    end
  end
end
