require 'formula'

class Ispell < Formula
  url 'http://www.lasr.cs.ucla.edu/geoff/tars/ispell-3.3.02.tar.gz'
  homepage 'http://lasr.cs.ucla.edu/geoff/ispell.html'
  md5 '12087d7555fc2b746425cd167af480fe'

  skip_clean :all

  # a little tricky since it doesn't use a configure script
  def install
    ENV.deparallelize
    ENV.no_optimization
    cp "local.h.macos", "local.h"
    chmod 0644, "local.h"
    inreplace "local.h" do |s|
      s.gsub! '/usr/local', prefix
      s.gsub! '/man/man', '/share/man/man'
    end
    chmod 0644, "correct.c"
    inreplace "correct.c", "getline", "getline_ispell"
    system "make config.sh"
    chmod 0644, "config.sh"
    inreplace "config.sh" do |s|
      s.gsub! '/usr/share/dict', "#{share}/dict"
      s.gsub! /yacc/, "/usr/bin/yacc"
    end
    lib.mkdir
    system "/usr/bin/make all"
    system "/usr/bin/make install"
  end

  def test
    %w{ buildhash defmt-c defmt-sh findaffix icombine ijoin ispell munchlist tryaffix}.each do |f|
      system "test -x #{bin}/" + f
    end
  end
end
