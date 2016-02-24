class Mktorrent < Formula
  desc "Create BitTorrent metainfo files"
  homepage "http://mktorrent.sourceforge.net/"
  url "https://downloads.sourceforge.net/mktorrent/mktorrent-1.0.tar.gz"
  sha256 "6f8e562af6366e0d9bde76e434f740b55722c6c3c555860dbe80083f9d1d119f"
  revision 1

  bottle do
    cellar :any
    sha256 "afd5e147727bc83fcde127e06f244513708045a295976d6571c23ee704f618f0" => :yosemite
    sha256 "79d448b9d2272a350d423668675a6b1504302505ae94af99f2a780efd0b82958" => :mavericks
    sha256 "7f9b38afb40e0f2fe2cde8209f942fa9c1367407593ef64cffc4996a49e97329" => :mountain_lion
  end

  depends_on "openssl"

  def install
    system "make USE_PTHREADS=1 USE_OPENSSL=1 USE_LONG_OPTIONS=1"
    bin.install "mktorrent"
  end
end
