require 'formula'

class Dbslayer < Formula
  homepage 'http://code.nytimes.com/projects/dbslayer/wiki'
  url 'http://code.nytimes.com/downloads/dbslayer-beta-12.tgz'
  version '0.12.b'
  sha1 'fbf1c5563a6ee45783e31f6b49612e64fc141186'

  depends_on :mysql

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make"
    system "make install"
  end
end
