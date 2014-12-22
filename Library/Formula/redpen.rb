class Redpen < Formula
  homepage "http://redpen.cc/"
  url "https://github.com/recruit-tech/redpen/releases/download/v1.0/redpen-1.0.tar.gz"
  sha1 "409c06450c35529d53ce5fe669c9fae662832cdf"

  depends_on :java => "1.8"

  def install
    libexec.install %w[bin lib]
    bin.install_symlink libexec+"bin/redpen"
  end

  test do
    system "#{bin}/redpen", "version"
  end
end
