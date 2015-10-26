class Desk < Formula
  desc "Lightweight workspace manager for the shell"
  homepage "https://github.com/jamesob/desk"
  url "https://github.com/jamesob/desk/archive/v0.1.1.tar.gz"
  sha256 "82a1529327a793a239f0c7ed9f4dad312da8c0317d8c5b459f05b6dd848e4860"

  def install
    bin.install "desk"
  end

  test do
    system "#{bin}/desk"
    system "#{bin}/desk", "ls"
    system "#{bin}/desk", "version"
  end
end
