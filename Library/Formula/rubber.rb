require 'formula'

class Rubber < Formula
  desc "Automated building of LaTeX documents"
  homepage 'https://launchpad.net/rubber/'
  url 'http://launchpad.net/rubber/trunk/1.1/+download/rubber-20100306.tar.gz'
  sha1 'cd382a19cc9fc65d114456ec9d6b042dc0e65b53'

  def install
    system "./configure", "--prefix=#{prefix}",
                          "--mandir=#{man}",
                          "--infodir=#{info}",
                          "--datadir=#{share}"
    system "make"
    system "make install"

    # Don't need to peg to a specific Python version
    inreplace Dir["#{bin}/*"], /^#!.*\/python.*$/, "#!/usr/bin/env python"
  end
end
