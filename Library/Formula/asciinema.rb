require 'formula'

class Asciinema < Formula
  homepage 'http://asciinema.org/'
  url 'https://github.com/sickill/asciinema/archive/v0.9.7.tar.gz'
  sha1 '1f93942163d36ea5ca94f9ee9c68d45c3a213148'

  depends_on :python

  def install
    system "python", "setup.py", "--prefix=#{prefix}"
  end

  def test
	system "#{bin}/asciinema", "--help"
	system "#{bin}/asciinema", "--version"
  end

end
