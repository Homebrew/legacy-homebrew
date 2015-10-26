class Desk < Formula
  desc "Lightweight workspace manager for the shell"
  homepage "https://github.com/jamesob/desk"
  url "https://github.com/jamesob/desk/archive/v0.1.1.tar.gz"
  sha256 "e3bd47be31637ea52e745fd8ca7bb1d07a3846350302cd24792a482ea042a1e9"

  def install
    bin.install "desk"
  end

  test do
    system "#{bin}/desk"
    system "#{bin}/desk", "ls"
    system "#{bin}/desk", "version"
  end
end
