class Tth < Formula
  desc "TeX/LaTeX to HTML converter"
  homepage "http://hutchinson.belmont.ma.us/tth/"
  url "http://hutchinson.belmont.ma.us/tth/tth_distribution/tth_4.06.tgz"
  sha256 "8e750f7532d87d97d0df380c688214885925f5c2032dc0c9d555af7f816416d1"
  revision 1

  bottle do
    cellar :any
    sha256 "d4f98342a0ad8edbbe8e740e2184626e32e88121ab68884c0e2902041257ce70" => :yosemite
    sha256 "fc85ad1d9985b45fbfbae6d2016c985ac9531a7a88c41f199c8386be414d5519" => :mavericks
    sha256 "81727008272c27d31ab334641f47049b07a9be6240efd9d5e02fa386e515008b" => :mountain_lion
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
