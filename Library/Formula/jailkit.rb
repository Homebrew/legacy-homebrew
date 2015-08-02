require 'formula'

class Jailkit < Formula
  desc "Utilities to create limited user accounts in a chroot jail"
  homepage 'http://olivier.sessink.nl/jailkit/'
  url 'http://olivier.sessink.nl/jailkit/jailkit-2.17.tar.bz2'
  sha1 '757891cc8915a133087164aa19719fef82f809ef'

  def install
      system "./configure", "--prefix=#{prefix}", "--disable-debug", "--disable-dependency-tracking"
      system "make install"
  end
end
