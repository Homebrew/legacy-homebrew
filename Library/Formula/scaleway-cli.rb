class ScalewayCli < Formula
  desc "Interact with Scaleway API from the command-line"
  homepage "https://github.com/scaleway/scaleway-cli/"
  url "https://github.com/scaleway/scaleway-cli/releases/download/v1.1.0/scw-Darwin-x86_64"
  version "1.1.0"
  sha256 "78ac104bf11f856ea50e7c75442264e5601214b5d33118648866250fcc0bff80"

  def install
    bin.install "scw-Darwin-x86_64" => "scw"
  end

  test do
    system "#{bin}/scw", "version"
  end
end
