class RbenvWhatis < Formula
  desc "Resolves abbreviations and aliases to Ruby versions"
  homepage "https://github.com/rkh/rbenv-whatis"
  url "https://github.com/rkh/rbenv-whatis/archive/v1.0.0.tar.gz"
  sha256 "1a09f824d1dcbca360565930fa66e93a9a2840c1bb45935e2ee989ce57d1f6e6"

  bottle :unneeded

  depends_on "rbenv"

  def install
    prefix.install Dir["*"]
  end

  test do
    system "rbenv", "whatis", "2.0"
  end
end
