require 'formula'

class Continuity < Formula
  homepage 'https://github.com/jzempel/continuity'
  url 'https://github.com/jzempel/continuity/tarball/0.2'
  md5 'cea964ca29e13ff2f589ffcfa27f1806'

  # The pyinstaller-built binary complains on strip.
  skip_clean 'bin'

  def install
    system "make", "prefix=#{prefix}", "install"
  end

  def test
    system "#{bin}/continuity", "--version"
  end
end
