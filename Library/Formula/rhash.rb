require 'formula'

class Rhash < Formula
  homepage 'http://rhash.anz.ru/'
  url 'http://downloads.sourceforge.net/project/rhash/rhash/1.3.0/rhash-1.3.0-src.tar.gz'
  sha1 'f51a7f3eea051ebef5c16db5c4a53ff3c2ef90c2'

  def install
    # install target isn't parallel-safe
    ENV.j1

    system 'make', 'install', "PREFIX=",
                              "DESTDIR=#{prefix}",
                              "CC=#{ENV.cc}"
  end
end
