require 'formula'

class FbClient < Formula
  homepage 'https://paste.xinu.at'
  url 'https://paste.xinu.at/data/client/fb-1.1.3.tar.gz'
  sha1 'e18605950735c6bd5e48636d7e7893235206e9cf'

  def install
    system "make", "PREFIX=#{prefix}", "install"
  end
end
