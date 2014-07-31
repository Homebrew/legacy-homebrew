require "formula"

class Serve < Formula
  homepage "https://github.com/kidoman/serve"
  url "https://github.com/kidoman/serve/archive/v0.2.2.tar.gz"
  sha1 "b2c5c35957c1176f265b31d5f7036b09eab5ee58"

  head "https://github.com/kidoman/serve.git"

  depends_on "go" => :build

  def install
    system "go", "build", "-o", "#{bin}/serve"
  end

  test do
    output = `#{bin}/serve -v`
    assert_equal 0, $?.exitstatus
  end
end
