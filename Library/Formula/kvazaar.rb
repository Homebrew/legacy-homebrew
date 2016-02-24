class Kvazaar < Formula
  desc "HEVC encoder"
  homepage "https://github.com/ultravideo/kvazaar"
  url "https://github.com/ultravideo/kvazaar/archive/v0.5.0.tar.gz"
  sha256 "2facdbffcf739171127487cd7d1e48c925560f39755a16542c4a40e65e293070"

  bottle do
    cellar :any
    sha256 "1cf96786d4613d94b93a8091027ea9d14ae6c801d11996def7c4b408316032e6" => :yosemite
    sha256 "aa78c8fa2657ccac25a0c3ac30d7840f281ab8af8a59aafb8058a122090e1b97" => :mavericks
    sha256 "5fc3c49c10479539474539e1bee928f89a3586f1f44e2f346c3b6484ff6395d2" => :mountain_lion
  end

  depends_on "yasm" => :build

  def install
    system "make", "-C", "src"
    bin.install "src/kvazaar"
  end

  test do
    assert_match "HEVC Encoder", shell_output("#{bin}/kvazaar 2>&1", 1)
  end
end
