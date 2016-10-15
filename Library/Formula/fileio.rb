class Fileio < Formula
  desc "Use file.io - an ephemeral file sharing service - from your terminal!"
  homepage "https://github.com/nicholaspufal/fileio-utility"
  url "https://github.com/nicholaspufal/fileio-utility/archive/v1.0.0.tar.gz"
  sha256 "8b59615669e5abdff87b2b77384380079e4340e934b607ad690a5b07d2e1358b"

  def install
    bin.install "fileio"
  end

  test do
    system "fileio", "--help"
  end
end
