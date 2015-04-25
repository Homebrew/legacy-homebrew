class Gitman < Formula
  homepage "https://github.com/jonstaff/gitman"
  url "https://github.com/jonstaff/gitman/archive/v1.0.tar.gz"
  sha256 "2e66ee543f53d95b040686c6175544ed85a59e9d0f273bba09789a8492ef9084"

  def install
    bin.install "gitman.py" => "gitman"
  end

  test do
    assert_match /^usage: gitman/, shell_output("#{bin}/gitman --help").strip
  end
end
