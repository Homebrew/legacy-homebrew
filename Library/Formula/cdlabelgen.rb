class Cdlabelgen < Formula
  desc "CD/DVD inserts and envelopes"
  homepage "http://www.aczoom.com/tools/cdinsert/"
  url "http://www.aczoom.com/pub/tools/cdlabelgen-4.3.0.tgz"
  sha256 "94202a33bd6b19cc3c1cbf6a8e1779d7c72d8b3b48b96267f97d61ced4e1753f"

  def install
    man1.mkpath
    system "make", "install", "BASE_DIR=#{prefix}"
  end

  test do
    system "#{bin}/cdlabelgen -c TestTitle --output-file testout.eps"
    File.file?("testout.eps")
  end
end
