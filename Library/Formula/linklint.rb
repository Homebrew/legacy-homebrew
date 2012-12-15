require 'formula'

class Linklint < Formula
  homepage 'http://linklint.org'
  url 'http://linklint.org/download/linklint-2.3.5.tar.gz'
  sha1 'd2dd384054b39a09c17b69e617f7393e44e98376'

  devel do
    url 'http://linklint.org/download/linklint-2.4.beta.tar.gz'
    sha1 'a159d19b700db52e8a9e2d89a0a8984eb627bf17'
  end

  def install
    mv 'READ_ME.txt', 'README'
    bin.install "linklint-#{version}" => "linklint"
  end
end
