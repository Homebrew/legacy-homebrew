require 'formula'

class Pwnat < Formula
  url 'http://samy.pl/pwnat/pwnat-0.3-beta.tgz'
  homepage 'http://samy.pl/pwnat/'
  sha1 '6faaeef76a2b62635def8fdef06fce0dfa3e870e'

  def install
    system "make", "CC=#{ENV.cc}", "CFLAGS=#{ENV.cflags}", "LDFLAGS=-lz"
    bin.install "pwnat"
  end
end
