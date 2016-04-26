class Snzip < Formula
  desc "Compression/decompression tool based on snappy"
  homepage "https://github.com/kubo/snzip"
  url "https://bintray.com/artifact/download/kubo/generic/snzip-1.0.3.tar.gz"
  sha256 "c83f1301cb1f1b64a25ef10e5fcfc2f6f66fa092ae833c524cad219c0ef2e990"

  bottle do
    cellar :any
    sha256 "048d8e5c33afda8fda06d5c65ba7da97c65527556ffe54e11f7a0aa1f1019ca0" => :el_capitan
    sha256 "3f0e1604d261a3d0aedc527a7e6242a11fe094aa1f635ae26e31da754eff6fdb" => :yosemite
    sha256 "d2399ea073c5b04fe1eeba5d7d7e3c288c5da72c295739c569b4af73f47d9e69" => :mavericks
  end

  depends_on "snappy"

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"test.out").write "test"
    system "#{bin}/snzip", "test.out"
    system "#{bin}/snzip", "-d", "test.out.sz"
  end
end
