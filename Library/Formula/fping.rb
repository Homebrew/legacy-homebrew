require 'formula'

class Fping < Formula
  homepage 'http://fping.org/'
  url 'http://fping.org/dist/fping-3.7.tar.gz'
  sha1 '6a6e3490a8ae80101a29afa90a72289db2d011ca'

  head 'https://github.com/schweikert/fping.git'

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end

end
