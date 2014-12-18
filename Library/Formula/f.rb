class F < Formula
  homepage "https://github.com/casey/f"
  url "https://github.com/casey/f/archive/0.1.0.tar.gz"
  sha1 "5dcf537a3b7b316c2891c4caa1a00c1fee001f5a"

  def install
    bin.install "f" => "f"
  end
end
