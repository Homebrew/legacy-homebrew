require 'formula'

class Rhash < Formula
  homepage 'http://rhash.anz.ru/'
  url 'https://downloads.sourceforge.net/project/rhash/rhash/1.3.1/rhash-1.3.1-src.tar.gz'
  sha1 '3ecba2786909cc0d8bff253d94b0f313cbf2a6b1'

  def install
    # install target isn't parallel-safe
    ENV.j1

    system 'make', 'install', "PREFIX=",
                              "DESTDIR=#{prefix}",
                              "CC=#{ENV.cc}"
  end
end
