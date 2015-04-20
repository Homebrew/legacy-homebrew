require 'formula'

class Ispell < Formula
  homepage 'http://lasr.cs.ucla.edu/geoff/ispell.html'
  url 'http://ftp.de.debian.org/debian/pool/main/i/ispell/ispell_3.3.02.orig.tar.gz'
  sha1 'c0d98e1af3afb8e0b642717c03439ff8881e3d60'

  def install
    ENV.deparallelize
    ENV.no_optimization

    # No configure script, so do this all manually
    cp "local.h.macos", "local.h"
    chmod 0644, "local.h"
    inreplace "local.h" do |s|
      s.gsub! '/usr/local', prefix
      s.gsub! '/man/man', '/share/man/man'
      s.gsub! '/lib', '/lib/ispell'
    end

    chmod 0644, "correct.c"
    inreplace "correct.c", "getline", "getline_ispell"

    system "make config.sh"
    chmod 0644, "config.sh"
    inreplace "config.sh", "/usr/share/dict", "#{share}/dict"

    (lib/'ispell').mkpath
    system "make all"
    system "make install"
  end
end
