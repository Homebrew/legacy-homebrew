require 'formula'

class Pit < Formula
  homepage 'https://github.com/michaeldv/pit'
  url 'https://github.com/michaeldv/pit/archive/0.1.0.tar.gz'
  sha1 '867698a2ef4d01587d81fe89dfd0e549d5b42e49'

  def install
    system "make"
    bin.install "bin/pit"
  end
end
