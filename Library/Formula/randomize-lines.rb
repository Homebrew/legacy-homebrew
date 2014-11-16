require 'formula'

class RandomizeLines < Formula
  homepage 'http://arthurdejong.org/rl/'
  url 'http://arthurdejong.org/rl/rl-0.2.7.tar.gz'
  sha1 '72d0bb0284b07560374e19f3c7983d64ba12bd95'

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "echo -e \"1\n2\n4\" | \"#{bin}/rl\" -c 1"
  end
end
