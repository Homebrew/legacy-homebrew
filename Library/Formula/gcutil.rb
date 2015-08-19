class Gcutil < Formula
  desc "Manage your Google Compute Engine resources"
  homepage "https://cloud.google.com/compute/docs/gcutil/"
  url "https://dl.google.com/dl/cloudsdk/release/artifacts/gcutil-1.16.1.zip"
  sha256 "31f438c9ce3471f1404340e3411239b28b63f117d17776271fee1e1a352f3877"

  def install
    libexec.install "gcutil", "lib"
    bin.install_symlink libexec/"gcutil"
  end

  test do
    system "#{bin}/gcutil", "version"
  end
end
