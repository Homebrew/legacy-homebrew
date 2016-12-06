class Desk < Formula
  desc "Lightweight workspace manager for the shell"
  homepage "https://github.com/jamesob/desk"
  url "https://github.com/jamesob/desk/archive/v0.1.2.tar.gz"
  sha256 "db6dfb80cbb012adf925a8002ce43e5e021b947917de4992bad06fc3cab16d23"

  def install
    bin.install "desk"
  end

  test do
    system "#{bin}/desk", "help"
    system "#{bin}/desk", "version"
  end
end
