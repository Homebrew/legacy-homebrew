class Nave < Formula
  homepage "https://github.com/isaacs/nave"
  url "https://github.com/isaacs/nave/archive/v0.5.0.tar.gz"
  sha1 "adfb72e9f57b14c94866d87001735c864d33c50f"

  def install
    bin.install "nave.sh" => "nave"
  end

  test do
    assert_match "0.10.30", shell_output("#{bin}/nave ls-remote")
  end
end
