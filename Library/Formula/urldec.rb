require 'formula'

class Urldec < Formula
  homepage 'http://www.aljex.com/bkw/sco/index.html'
  url 'http://www.aljex.com/bkw/sco/urldec-src.tar.bz2'
  sha1 '5ba9fe7952a2fd135f1963faccab68ae77cef7d3'

  def install
    ENV.deparallelize

    system "rm urldec urlenc"

    inreplace 'Makefile' do |s|
      s.gsub! /\/man\//, "/share/man/"
    end

    system "make install"
  end
end

