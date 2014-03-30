require 'formula'

class Serve < Formula
  homepage "https://github.com/kidoman/serve"
  url "https://github.com/kidoman/serve/archive/v0.1.1.zip"
  sha1 "091cd9f184fab6024913938d1f88f39c5e2a7835"

  head "https://github.com/kidoman/serve.git", :branch => "master"

  depends_on "go" => :build

  def install
    system "go build -o #{bin}/serve"
  end

  test do
    system "#{bin}/serve", "-h"
  end
end