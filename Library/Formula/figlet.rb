require 'formula'

class ContribFonts < Formula
  url 'ftp://ftp.figlet.org:21//pub/figlet/fonts/contributed.tar.gz'
  sha1 'a23ecfdb54301e93b6578c3c465ba84c8f861d4f'
  version '2.2.4'
end

class InternationalFonts < Formula
  url 'ftp://ftp.figlet.org:21//pub/figlet/fonts/international.tar.gz'
  sha1 '4bdc505f82305debf8108b725ac418f404a8bcb0'
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
