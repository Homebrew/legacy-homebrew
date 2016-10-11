class Mackey < Formula
  homepage "https://github.com/docwhat/mackey"
  url "https://github.com/docwhat/mackey/archive/v1.0.3.tar.gz"
  sha1 "26577be98013bc5167261d1e16dc244c5da616a8"
  head "https://github.com/docwhat/mackey.git"

  def install
    system "./configure"
    bin.install "bin/mackey"
    prefix.install "bundle"
  end

  test do
    system "#{bin}/mackey"
  end
end
