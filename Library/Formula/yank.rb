class Yank < Formula
  desc "Yank terminal output to clipboard"
  homepage "https://github.com/mptre/yank"
  url "https://github.com/mptre/yank/archive/v0.4.0.tar.gz"
  sha256 "1adf1b07f7cb9401daeed7a05bad492db8ed77ead4728d9b45f541d56bc2e8c5"

  def install
    system "make", "install", "PREFIX=#{prefix}", "YANKCMD=pbcopy"
  end

  test do
    system "#{bin}/yank", "-v"
    system "man", "yank"
  end
end
