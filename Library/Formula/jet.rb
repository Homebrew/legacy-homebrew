class Jet < Formula
  desc "CLI for Codeships Docker infrastructure"
  homepage "https://codeship.com/documentation/docker/release-notes/"
  url "https://s3.amazonaws.com/codeship-jet-releases/0.13.0/jet-darwin_amd64_0.13.0.tar.gz"
  sha256 "5a0c862f6111fd09ba1e3b7ea8242dbc95b0d51d3f4aa609bf1aa58c1af17514"

  def install
    bin.install "jet"
  end

  test do
    system "#{bin}/jet", "version"
  end
end
