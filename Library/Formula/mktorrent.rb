class Mktorrent < Formula
  desc "Create BitTorrent metainfo files"
  homepage "http://mktorrent.sourceforge.net/"
  url "https://downloads.sourceforge.net/mktorrent/mktorrent-1.0.tar.gz"
  sha256 "6f8e562af6366e0d9bde76e434f740b55722c6c3c555860dbe80083f9d1d119f"

  def install
    system "make USE_PTHREADS=1 USE_OPENSSL=1 USE_LONG_OPTIONS=1"
    bin.install "mktorrent"
  end
end
