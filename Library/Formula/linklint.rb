require 'formula'

class Linklint < Formula
  homepage 'http://linklint.org'
  url 'http://linklint.org/download/linklint-2.3.5.tar.gz'
  sha1 'd2dd384054b39a09c17b69e617f7393e44e98376'

  def install
    mv 'READ_ME.txt', 'README'
    bin.install 'linklint-2.3.5' => 'linklint'
  end
end
