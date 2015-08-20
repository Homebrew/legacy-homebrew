class Rl < Formula
  desc "rl is a command-line tool that reads lines from an input file or stdin, randomizes the lines and outputs a specified number of lines."
  homepage "http://arthurdejong.org/rl/"
  url "http://arthurdejong.org/rl/rl-0.2.7.tar.gz"
  version "0.2.7"
  sha256 "1cfca23d6a14acd190c5a6261923757d20cb94861c9b2066991ec7a7cae33bc8"

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system bin/"rl", "--version"
  end
end
