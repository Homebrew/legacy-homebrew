require "formula"
require "tempfile"

class Icdiff < Formula
  homepage "https://github.com/jeffkaufman/icdiff"
  url "https://github.com/jeffkaufman/icdiff/archive/release-1.1.2.tar.gz"
  sha1 "89cfb79237a59ed33c55fb020965f7c94e7510bc"
  version "1.1.2"

  def install
    bin.install "icdiff", "git-icdiff"
  end

  test do
    system "#{bin}/icdiff", Tempfile.new('ic-diff').path, Tempfile.new('ic-diff').path
    system "git", "init"
    system "#{bin}/git-icdiff"
  end
end
