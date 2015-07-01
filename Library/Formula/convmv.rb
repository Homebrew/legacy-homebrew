class Convmv < Formula
  desc "Filename encoding conversion tool"
  homepage "https://www.j3e.de/linux/convmv/"
  url "https://www.j3e.de/linux/convmv/convmv-2.0.tar.gz"
  sha256 "170cf675be1fca77868ff472e9340ca828b1463865a63d4f4b7b3bf4053db93f"

  def install
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    system "#{bin}/convmv", "--list"
  end
end
