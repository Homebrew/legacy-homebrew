require 'formula'

class Gitstats < Formula
  homepage 'http://gitstats.sourceforge.net/'
  url 'https://github.com/hoxu/gitstats/tarball/e6b3058337731b59455c18194cccd3abcc9eb721'
  sha1 '9db86bc3b42e5c172d5d0cb571bdf0d1896cd685'

  head 'https://github.com/hoxu/gitstats/tarball/master'

  depends_on 'gnuplot'

  def install
    system "make", "install", "PREFIX=#{prefix}"
  end

  def test
    system "gitstats"
  end
end
