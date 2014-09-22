require "formula"

class Scrypt < Formula
  homepage "https://www.tarsnap.com/scrypt.html"
  url "https://www.tarsnap.com/scrypt/scrypt-1.1.6.tgz"
  sha256 "dfd0d1a544439265bbb9b58043ad3c8ce50a3987b44a61b1d39fd7a3ed5b7fb8"

  bottle do
    cellar :any
    sha1 "7886f689ff87097389b38de18ecbd6a6122de393" => :mavericks
    sha1 "ee18f05a2a5f03029eff09112210c9dd91a88be1" => :mountain_lion
    sha1 "55a0f5c9af71e15f801c1a94252150a356e73b20" => :lion
  end

  depends_on "openssl"

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end
end
