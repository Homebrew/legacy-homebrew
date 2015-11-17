class Libksba < Formula
  desc "X.509 and CMS library"
  homepage "https://www.gnupg.org/related_software/libksba/index.en.html"
  url "ftp://ftp.gnupg.org/gcrypt/libksba/libksba-1.3.3.tar.bz2"
  mirror "https://www.mirrorservice.org/sites/ftp.gnupg.org/gcrypt/libksba/libksba-1.3.3.tar.bz2"
  sha256 "0c7f5ffe34d0414f6951d9880a46fcc2985c487f7c36369b9f11ad41131c7786"

  bottle do
    cellar :any
    sha256 "f455678eb6f38f3c0d07b174b4c2f1b8d3a034b64996f0db9ea14ad559e2fbcb" => :el_capitan
    sha256 "6ac68b0bd118c3f1e0440af4f805b75e925f4c2dde6ab466fb117323ac23dc92" => :yosemite
    sha256 "38108681341eae8a7b196c356ad790f265663f794c5eb7eea5378579c920356b" => :mavericks
    sha256 "b0428dd17c910797a627f9a7d85ee1bc6deeb0a3354d2aaa1bf400ceb6ad682c" => :mountain_lion
  end

  depends_on "libgpg-error"

  def install
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}",
                          "--disable-silent-rules"
    system "make", "install"
  end

  test do
    system "#{bin}/ksba-config", "--libs"
  end
end
