class Docutils < Formula
  desc "Text processing system for processing plaintext documentation into useful formats"
  homepage "http://docutils.sourceforge.net"
  url "http://downloads.sourceforge.net/project/docutils/docutils/0.12/docutils-0.12.tar.gz"
  sha256 "c7db717810ab6965f66c8cf0398a98c9d8df982da39b4cd7f162911eb89596fa"

  def install
    system "python", "setup.py", "install", "--prefix=#{prefix}"
  end
end

