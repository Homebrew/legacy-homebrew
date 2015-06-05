class Tf < Formula
  homepage "https://github.com/mickep76/tf"
  url "https://github.com/mickep76/tf/archive/0.2.tar.gz"
  sha256 "b59730cfbc3c62027bd91942c70d3d07c2bbc4f82b0332d17da977bb7f2041bc"

  depends_on "go" => :build

  def install
    system "./gobuild.sh"
    bin.install ".gobuild/bin/tf" => "tf"
  end

  test do
    system "#{bin}/tf", "--help"
  end
end
