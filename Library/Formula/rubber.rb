require 'formula'

class Rubber <Formula
  url 'http://launchpad.net/rubber/trunk/1.1/+download/rubber-20100306.tar.gz'
  homepage 'https://launchpad.net/rubber/'
  md5 'f3e41773853db232630d4a71636b2ba4'

  def patches
    # Creates missing .in files and adds them to the configure phase
    # otherwise rubber modules are not found after install
    "http://gist.github.com/raw/370408/484d76d042e936053de41fbbe48f5dbdbd1b71b8/fix_rubber_configure.patch"
  end

  def install
    system "./configure", "--prefix=#{prefix}",
                          "--mandir=#{man}",
                          "--infodir=#{info}",
                          "--datadir=#{share}"
    system "make"
    system "make install"

    # Don't need to peg to a specific Python version
    Dir["#{bin}/*"].each do |f|
      inreplace f, "#{HOMEBREW_PREFIX}/bin/python", "/usr/bin/env python"
    end
  end
end
