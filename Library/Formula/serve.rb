require "formula"

class Serve < Formula
  homepage "https://github.com/kidoman/serve"
  url "https://github.com/kidoman/serve/archive/v0.2.3.tar.gz"
  sha1 "cb4bc4a7cb7a321e104bcc76aa31390205b39752"

  head "https://github.com/kidoman/serve.git"

  depends_on "go" => :build

  def install
    system "go", "build", "-o", "#{bin}/serve"
  end

  test do
    system "#{bin}/serve", "-v"
  end
end
