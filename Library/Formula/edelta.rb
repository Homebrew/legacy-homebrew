class Edelta < Formula
  desc "XDelta-style binary differ"
  homepage "http://www.diku.dk/hjemmesider/ansatte/jacobg/edelta/"
  url "http://www.diku.dk/hjemmesider/ansatte/jacobg/edelta/edelta-0.10b.tar.gz"
  sha256 "86d60b8726d37d5486b0d8030492a99b2f4ce1266ad50a99edb07ee6d529815e"

  bottle do
    cellar :any
    sha256 "899ebc5dcf01081e885bef90c53ea6ccf9763562b8fc9e778dd4cac9d2ee4c83" => :yosemite
    sha256 "cb69b6278bf6ffe5430d33718db74cc35ea7982e48775c1d9723f514a6fc6e82" => :mavericks
    sha256 "e266224b0d63f429b0009564ecd74d51733434a3fc4f6509141157340682bdc0" => :mountain_lion
  end

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
