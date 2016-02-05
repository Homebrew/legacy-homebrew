class Xxhash < Formula
  desc "Extremely fast non-cryptographic hash algorithm"
  homepage "https://github.com/Cyan4973/xxHash"
  url "https://github.com/Cyan4973/xxHash/archive/r42.tar.gz"
  version "r42"
  sha256 "d21dba3ebf5ea8bf2f587150230189231c8d47e8b63c865c585b08d14c8218b8"

  bottle do
    cellar :any_skip_relocation
    sha256 "6edf8933719f867a437b3b99eed77ba7e6207676524ff7bbf9b7dbe4b56af31f" => :el_capitan
    sha256 "70786baab2979107795449762885b97df42b412e475b06d3266046339d93023d" => :yosemite
    sha256 "c14a9879b1a280788f255714ba2837d605ed00b33c1678f019eaf10007790dd0" => :mavericks
  end

  def install
    system "make"
    bin.install "xxhsum"
  end

  test do
    (testpath/"leaflet.txt").write "No computer should be without one!"
    assert_match /^67bc7cc242ebc50a/, shell_output("#{bin}/xxhsum leaflet.txt")
  end
end
