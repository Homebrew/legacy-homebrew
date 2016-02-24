class N < Formula
  desc "Node version management"
  homepage "https://github.com/tj/n"
  head "https://github.com/tj/n.git"
  url "https://github.com/tj/n/archive/v2.1.0.tar.gz"
  sha256 "6fb70b39065a6d6ba1d12915906c06907a3e1afbb25c7653ad23a21217f51c76"

  bottle do
    cellar :any_skip_relocation
    sha256 "c3c3d85ecf24faaa4fd58531bc231ec811a9d2839d5aeae4112e0c47a36ea5ac" => :el_capitan
    sha256 "e71ab24dcf496d2022327fe70fb7ee2fbf5fc66ebc5895c856d85e2825a662f8" => :yosemite
    sha256 "da5e7575c5f86216e67a43068071d0441db7d2ef91a2058c1d383a02a0bad173" => :mavericks
  end

  def install
    bin.mkdir
    system "make", "PREFIX=#{prefix}", "install"
  end

  test do
    system bin/"n", "ls"
  end
end
