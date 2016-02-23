class Libtomcrypt < Formula
  desc "Modular and portable cryptographic toolkit"
  homepage "http://www.libtom.net/LibTomCrypt/"
  url "https://github.com/libtom/libtomcrypt/releases/download/1.17/crypt-1.17.tar.bz2"
  mirror "https://distfiles.macports.org/libtomcrypt/crypt-1.17.tar.bz2"
  sha256 "e33b47d77a495091c8703175a25c8228aff043140b2554c08a3c3cd71f79d116"
  head "https://github.com/libtom/libtomcrypt.git"

  bottle do
    cellar :any
    revision 2
    sha256 "ad36e0538d35fe35f71a1c5d7c19945a2800e791911a53bf1168b9bbc6df8db1" => :yosemite
    sha256 "108baa1e0008f5967f5dae0f670558bcb0bd679c94deb2d21d335525beda21ac" => :mavericks
    sha256 "dd8857ae5f03d3e26c9f741b13522f0e868539264ab9c3dceb26f6019fe1996c" => :mountain_lion
  end

  depends_on "libtommath"

  def install
    ENV["DESTDIR"] = prefix
    ENV["EXTRALIBS"] = "-ltommath"
    ENV.append "CFLAGS", "-DLTM_DESC -DUSE_LTM"

    system "make", "library"
    include.install Dir["src/headers/*"]
    lib.install "libtomcrypt.a"
  end
end
