class Goose < Formula
  homepage "https://github.com/andersjanmyr/goose"
  url "https://github.com/andersjanmyr/goose/archive/v1.3.2.tar.gz"
  sha256 "a262722d00992163c36066d69734f284212d559bc9843a4d0496469228fa723f"

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    system "./build"
    bin.install "bin/goose"

    bash_completion.install "goose_completion.sh"
  end

  test do
    system "#{bin}/goose", "--version"
  end
end

