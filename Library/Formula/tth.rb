class Tth < Formula
  desc "TeX/LaTeX to HTML converter"
  homepage "http://hutchinson.belmont.ma.us/tth/"
  url "http://hutchinson.belmont.ma.us/tth/tth_distribution/tth_4.06.tgz"
  sha1 "ba3c653bf05d25ac8a907fb1d51184da1ac42721"
  revision 1

  bottle do
    cellar :any
    sha1 "694f5f4dea4af1acfcec5b53d949ec58dec75459" => :yosemite
    sha1 "ea2b08272a5cc8f5e890d36624f1f94b003c0a0b" => :mavericks
    sha1 "5be595e24438680c3c06f1812ff1e1e9a03c1732" => :mountain_lion
  end

  def install
    system ENV.cc, "-o", "tth", "tth.c"
    bin.install %w[tth latex2gif ps2gif ps2png]
    man1.install "tth.1"
  end

  test do
    assert_match(/version #{version}/, pipe_output("#{bin}/tth", ""))
  end
end
