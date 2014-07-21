require 'formula'

class Rubber < Formula
  homepage 'https://launchpad.net/rubber/'
  url 'http://launchpad.net/rubber/trunk/1.1/+download/rubber-20100306.tar.gz'
  sha1 'cd382a19cc9fc65d114456ec9d6b042dc0e65b53'

  # Creates missing .in files and adds them to the configure phase
  # otherwise rubber modules are not found after install
  patch do
    url "https://gist.githubusercontent.com/mgee/370408/raw/484d76d042e936053de41fbbe48f5dbdbd1b71b8/fix_rubber_configure.patch"
    sha1 "29173bd22b7ae6216d1255597b6755931df9a33e"
  end

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
