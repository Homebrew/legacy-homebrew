class Mongroup < Formula
  desc "Monitor a group of processes with mon"
  homepage "https://github.com/jgallen23/mongroup"
  url "https://github.com/jgallen23/mongroup/archive/0.4.1.tar.gz"
  sha256 "50c6fb0eb6880fa837238a2036f9bc77d2f6db8c66b8c9a041479e2771a925ae"

  bottle do
    cellar :any
    sha1 "362393e9e2409030379af478625bc1eac846acef" => :mavericks
    sha1 "a813a9be26dd962ab7dd1a2e4f8b53adcb082b25" => :mountain_lion
    sha1 "988c86f7ef36e75354dc676028d5ed560ecd3ae5" => :lion
  end

  depends_on "mon"

  def install
    bin.mkpath
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    system "#{bin}/mongroup", "-V"
  end
end
