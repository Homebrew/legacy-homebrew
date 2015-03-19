class Pidcat < Formula
  homepage "https://github.com/JakeWharton/pidcat"
  head "https://github.com/JakeWharton/pidcat.git"
  url "https://github.com/JakeWharton/pidcat/archive/1.4.1.tar.gz"
  sha256 "5e4d340b9b89cc0c23562714acacd6ccb56c509859907782d6a0ced44b170b3d"

  def install
    bin.install "pidcat.py" => "pidcat"
  end

  test do
    assert_match /^usage: pidcat/, shell_output("#{bin}/pidcat --help").strip
  end
end
