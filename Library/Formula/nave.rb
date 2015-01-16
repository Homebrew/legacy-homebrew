class Nave < Formula
  homepage "https://github.com/isaacs/nave"
  url "https://github.com/isaacs/nave/archive/v0.4.5.tar.gz"
  sha1 "190fdab025882a9a50d85c2509b04f269f97dbf7"

  def install
    bin.install "nave.sh" => "nave"
  end

  test do
    assert_match /0\.10\.30/, shell_output("#{bin}/nave ls-remote")
  end
end
