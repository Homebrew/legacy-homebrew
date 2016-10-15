class Geodig < Formula
  homepage "https://github.com/dutchcoders/geodig"
  url "https://github.com/dutchcoders/geodig/archive/v1.0.0.tar.gz"
  sha256 "b6a16313ac64cbe8fadc2284ca537973854f1a608eea3b170fcf369e4e240821"
  head "https://github.com/dutchcoders/geodig.git"

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath

    mkdir_p "src/github.com/dutchcoders/"
    ln_s buildpath, "src/github.com/dutchcoders/geodig"

    system "go", "get", "github.com/oschwald/maxminddb-golang"
    system "go", "build", "-o", "geodig"

    bin.install "geodig"
  end

  test do
    system "#{bin}/geodig", "brew.sh"
  end
end
