class Mongroup < Formula
  desc "Monitor a group of processes with mon"
  homepage "https://github.com/jgallen23/mongroup"
  url "https://github.com/jgallen23/mongroup/archive/0.4.1.tar.gz"
  sha256 "50c6fb0eb6880fa837238a2036f9bc77d2f6db8c66b8c9a041479e2771a925ae"

  bottle do
    cellar :any
    sha256 "39b8052e644bf78570cd9393f3229843445784e93f6891924ae05c118c3bc16b" => :mavericks
    sha256 "5279c40b110406b0cdd3e62c6ea978a1a02f6a9601fadc414bd8edd04ed8ca7f" => :mountain_lion
    sha256 "5803b417bacf1630a0044485342af46471a4107116ff05d65ad62330234a96c7" => :lion
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
