require "formula"

class Pidcat < Formula
  homepage "https://github.com/JakeWharton/pidcat"
  head "https://github.com/JakeWharton/pidcat.git"
  url "https://github.com/JakeWharton/pidcat/archive/1.4.1.tar.gz"
  sha1 "89f806ae1fa3375ce188851c8c95fc1097467b82"

  def install
    bin.install "pidcat.py" => "pidcat"
  end

  test do
    assert_match /^usage: pidcat/, shell_output("#{bin}/pidcat --help").strip
  end
end
