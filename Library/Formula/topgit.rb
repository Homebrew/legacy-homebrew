require 'formula'

class Topgit < Formula
  homepage 'https://github.com/greenrd/topgit'
  url 'https://github.com/greenrd/topgit.git', :revision => 'f2815f4debdb07f86ee86dd4eb75280919ace55d'
  version '0.9'

  def install
    system "make", "install", "prefix=#{prefix}"
  end
end
