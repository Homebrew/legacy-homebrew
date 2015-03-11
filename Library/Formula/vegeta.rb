require "language/go"

class Vegeta < Formula
  homepage "https://github.com/tsenart/vegeta"
  url "https://github.com/tsenart/vegeta/archive/v5.5.3.tar.gz"
  sha1 "f1813f5dc1bbcbd2d0d627c997d41ea7f466919a"

  bottle do
    cellar :any
    sha256 "a8d0252c29c1de7e34088bef3b0626820ee605ed3abc6f918f32c7706d5669aa" => :yosemite
    sha256 "630824373d85b313faf19576206a1f5a81bd856c1e5dc0add9440d0742d31010" => :mavericks
    sha256 "f9e4067f952412ae098b536cf7e56b92ff0e48672ec1b7f46ca81a575da24cf4" => :mountain_lion
  end

  depends_on "go" => :build

  go_resource "github.com/bmizerany/perks" do
    url "https://github.com/bmizerany/perks.git",
      :revision => "6cb9d9d729303ee2628580d9aec5db968da3a607"
  end

  def install
    mkdir_p buildpath/"src/github.com/tsenart/"
    ln_s buildpath, buildpath/"src/github.com/tsenart/vegeta"
    ENV["GOPATH"] = buildpath
    Language::Go.stage_deps resources, buildpath/"src"

    system "go", "build", "-o", "vegeta"
    bin.install "vegeta"
  end

  test do
    pipe_output("#{bin}/vegeta attack -duration=1s -rate=1", "GET http://localhost/")
  end
end
