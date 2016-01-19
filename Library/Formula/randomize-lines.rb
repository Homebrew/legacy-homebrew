class RandomizeLines < Formula
  desc "Reads and randomize lines from a file (or STDIN)"
  homepage "http://arthurdejong.org/rl/"
  url "http://arthurdejong.org/rl/rl-0.2.7.tar.gz"
  sha256 "1cfca23d6a14acd190c5a6261923757d20cb94861c9b2066991ec7a7cae33bc8"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "echo -e \"1\n2\n4\" | \"#{bin}/rl\" -c 1"
  end
end
