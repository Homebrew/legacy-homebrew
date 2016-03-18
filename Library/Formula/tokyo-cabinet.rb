class TokyoCabinet < Formula
  desc "Lightweight database library"
  homepage "http://fallabs.com/tokyocabinet/"
  url "http://fallabs.com/tokyocabinet/tokyocabinet-1.4.48.tar.gz"
  mirror "https://mirrorservice.org/sites/ftp.debian.org/debian/pool/main/t/tokyocabinet/tokyocabinet_1.4.48.orig.tar.gz"
  sha256 "a003f47c39a91e22d76bc4fe68b9b3de0f38851b160bbb1ca07a4f6441de1f90"

  bottle do
    revision 1
    sha256 "a209fa62fdb84a86784de5eb9699a9a6811c962afab2ebf418b2a712f51852d8" => :el_capitan
    sha256 "3267823914e250aff7c8d3a5a686a010f0fc96242a417dbf47bb1502aa020ad6" => :yosemite
    sha256 "8d8e93ed60945cfb729395882e69d3924d899c8f792eab73a6094aa78b47c75c" => :mavericks
  end

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end
end
