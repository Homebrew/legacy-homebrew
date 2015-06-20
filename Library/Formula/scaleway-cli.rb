require "formula"

class ScalewayCli < Formula
  desc "Interact with Scaleway API from the command line"
  homepage "https://github.com/scaleway/scaleway-cli/"
  url "https://github.com/scaleway/scaleway-cli/releases/download/v1.1.0/scw-Darwin-x86_64"
  sha1 "8860b5daf4af43684c523aab62c48ee7e99517d4"

  def install
    mv 'scw-Darwin-x86_64', 'scw'
    bin.install 'scw'
  end

  test do
    system "#{bin}/scw", "version"
  end
end
