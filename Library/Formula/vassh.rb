require "formula"

class Vassh < Formula
  homepage "https://github.com/x-team/vassh"
  url "https://github.com/x-team/vassh/archive/0.2.tar.gz"
  sha1 "b7be90ab0a20f3edebe45dab2f7a048684871068"

  def install
    bin.install "vassh.sh", "vasshin", "vassh"
  end

  test do
    system "#{bin}/vassh", "-h"
  end
end
