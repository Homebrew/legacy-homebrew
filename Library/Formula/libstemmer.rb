require 'formula'

class Libstemmer < Formula
  url 'http://snowball.tartarus.org/dist/libstemmer_c.tgz'
  homepage 'http://snowball.tartarus.org/'
  md5 '4b0a9455f6bcba01c8ab2b2f50e27178'
  version '1.0' # can't find version number on website or source code :(

  def install
    system "make"

    lib.mkpath
    lib.install("libstemmer.o")

    include.mkpath
    include.install "include/libstemmer.h"
  end
end
