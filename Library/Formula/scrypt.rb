class Scrypt < Formula
  desc "Encrypt and decrypt files using memory-hard password function"
  homepage "https://www.tarsnap.com/scrypt.html"
  url "https://www.tarsnap.com/scrypt/scrypt-1.2.0.tgz"
  sha256 "1754bc89405277c8ac14220377a4c240ddc34b1ce70882aa92cd01bfdc8569d4"

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
