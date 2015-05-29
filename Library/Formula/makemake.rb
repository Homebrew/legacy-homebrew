class Makemake < Formula
  homepage "https://github.com/Julow/makemake"
  desc "Cool Makefile generator (C/C++)"
  url "https://github.com/Julow/makemake.git", :tag => "1.0-release", :revision => "f3ebda821b4e859cfdd20b579d1074c86330d14f"
  head "https://github.com/Julow/makemake.git"
  sha256 "47b79f953e39db26d4cdd612572c52e9a06b7899025ef53ed874baa4a7a03b23"
  def install
    bin.install "makemake.py" => "makemake"
  end
  test do
    system "#{bin}/makemake", "--test"
    assert File.exist? "Makefile"
  end
end
