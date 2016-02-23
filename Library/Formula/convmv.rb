class Convmv < Formula
  desc "Filename encoding conversion tool"
  homepage "https://www.j3e.de/linux/convmv/"
  url "https://www.j3e.de/linux/convmv/convmv-2.0.tar.gz"
  sha256 "170cf675be1fca77868ff472e9340ca828b1463865a63d4f4b7b3bf4053db93f"

  bottle do
    cellar :any_skip_relocation
    sha256 "ba37232c28cd67ad8b553b79b9e4caccaf9571eb05658bf4ac287be2e490094e" => :el_capitan
    sha256 "0293e2f79297e7be509804444fe9ec437ae12f38a2aafab226b27fc2c41da1fe" => :yosemite
    sha256 "14eb563118272c69d38b71a972976a0736757c529741c154ba311c1d9082313a" => :mavericks
    sha256 "355114a774c9a036a10e77e8e8570f783fe57e50847c3c7f7bd449f016862900" => :mountain_lion
  end

  def install
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    system "#{bin}/convmv", "--list"
  end
end
