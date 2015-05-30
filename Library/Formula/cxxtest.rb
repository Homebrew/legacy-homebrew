class Cxxtest < Formula
  desc "CxxTest Unit Testing Framework"
  homepage "http://cxxtest.com"
  url "https://github.com/CxxTest/cxxtest/archive/4.3.tar.gz"
  sha256 "356d0f4810e8eb5c344147a0cca50fc0d84122c286e7644b61cb365c2ee22083"

  def install
    libexec.install Dir["*"]
    bin.install_symlink "#{libexec}/bin/cxxtestgen"
    include.install_symlink "#{libexec}/cxxtest"
  end

  test do
    system "#{bin}/cxxtestgen", "--version"
  end
end
