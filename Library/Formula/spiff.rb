class Spiff < Formula
  desc "Tool and declarative YAML templating system specially for BOSH manifests."
  homepage "https://github.com/cloudfoundry-incubator/spiff"
  url "https://github.com/cloudfoundry-incubator/spiff/releases/download/v1.0.7/spiff_darwin_amd64.zip"
  version "1.0.7"
  sha256 "482b77c522e5d8ac95cfe1b8e785f5d4fe9183f7d25122fa18d271cac6a3dbbe"

  def install
    bin.install "spiff"
  end

  test do
    system "#{bin}/spiff"
  end
end
