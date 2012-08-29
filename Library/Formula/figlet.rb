require 'formula'

class ContribFonts < Formula
  url 'ftp://ftp.figlet.org:21//pub/figlet/fonts/contributed.tar.gz'
  md5 '6e2dec4499f7a7fe178522e02e0b6cd1'
  version '2.2.4'
end

class InternationalFonts < Formula
  url 'ftp://ftp.figlet.org:21//pub/figlet/fonts/international.tar.gz'
  md5 'b2d53f7e251014adcdb4d407c47f90ef'
  version '2.2.4'
end

class Figlet < Formula
  homepage 'http://www.figlet.org'
  url 'ftp://ftp.figlet.org/pub/figlet/program/unix/figlet-2.2.5.tar.gz'
  sha1 'dda696958c161bd71d6590152c94c4f705415727'

  def install
    share_fonts = share+"figlet/fonts"

    File.chmod 0666, 'Makefile'
    File.chmod 0666, 'showfigfonts'
    man6.mkpath
    bin.mkpath

    ContribFonts.new.brew { share_fonts.install Dir['*'] }
    InternationalFonts.new.brew { share_fonts.install Dir['*'] }

    system "make", "prefix=#{prefix}",
                   "DEFAULTFONTDIR=#{share_fonts}",
                   "MANDIR=#{man}",
                   "install"
  end

  def test
    system "#{bin}/figlet", "-f", "larry3d", "hello, figlet"
  end
end
