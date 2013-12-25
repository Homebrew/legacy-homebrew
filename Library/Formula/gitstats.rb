require 'formula'

class Gitstats < Formula
  homepage 'http://gitstats.sourceforge.net/'
  url 'https://github.com/hoxu/gitstats/archive/a266ddc1ccd281739a916e064756d1f9ac0f1f52.zip'
  sha1 '583e918d2ff4bf34ca498254d8049ff43b6ac536'

  def install
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    system "#{bin}/gitstats"
  end
end
