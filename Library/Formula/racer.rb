class Racer < Formula
  desc "Rust Auto-Complete-er"
  homepage "https://github.com/phildawes/racer"
  url "https://github.com/phildawes/racer/archive/v1.0.0.tar.gz"
  sha256 "78895296ed688eeccbaf7745235f0fc503407bfa718f53583a4dcc9e1246b7f5"
  head "https://github.com/phildawes/racer.git"

  depends_on "Rust" => :build

  def install
    system "cargo", "build", "--release"
    cd "target/release" do
      bin.install "racer"
    end
  end

  test do
    system "#{bin}/racer"
  end
end
