class Grap < Formula
  desc "Language for typesetting graphs"
  homepage "http://www.lunabase.org/~faber/Vault/software/grap/"
  url "http://www.lunabase.org/~faber/Vault/software/grap/grap-1.45.tar.gz"
  sha256 "906743cdccd029eee88a4a81718f9d0777149a3dc548672b3ef0ceaaf36a4ae0"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}",
                          "--with-example-dir=#{share}/grap/examples"
    system "make"
    ENV.deparallelize
    system "make", "install"
  end

  test do
    (testpath/"test.d").write <<-EOS.undent
      .G1
      54.2
      49.4
      49.2
      50.0
      48.2
      43.87
      .G2
    EOS
    system bin/"grap", testpath/"test.d"
  end
end
