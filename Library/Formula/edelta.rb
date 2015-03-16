class Edelta < Formula
  homepage "http://www.diku.dk/hjemmesider/ansatte/jacobg/edelta/"
  url "http://www.diku.dk/hjemmesider/ansatte/jacobg/edelta/edelta-0.10b.tar.gz"
  sha256 "86d60b8726d37d5486b0d8030492a99b2f4ce1266ad50a99edb07ee6d529815e"

  def install
    system "make", "CFLAGS=#{ENV.cflags}"
    bin.install "edelta"
  end

  test do
    (testpath/"test1").write "foo"
    (testpath/"test2").write "bar"

    system "#{bin}/edelta", "delta", "test1", "test2"
  end
end
