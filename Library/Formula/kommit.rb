class Kommit < Formula
  desc "More detailed commit messages without committing!"
  homepage "https://github.com/bilgi-webteam/kommit"
  url "https://github.com/bilgi-webteam/kommit/archive/v1.1.0.tar.gz"
  sha256 "c51e87c9719574feb9841fdcbd6d1a43b73a45afeca25e1312d2699fdf730161"

  bottle do
    cellar :any_skip_relocation
    sha256 "2797509de1497eeae3a3cac0381822019e471e878f5082b1a79fa40bc2f6f768" => :el_capitan
    sha256 "b15cf7fe56aceade3a06d52e467cdb08640f4d907d1a29dcef0e374815dee203" => :yosemite
    sha256 "8f7d60cb1b837a3a1e1e7ae86d339c1a950ba3577e3053819ac9922144a6d0d3" => :mavericks
  end

  def install
    bin.install "bin/git-kommit"
  end

  test do
    system "git", "init"
    system "#{bin}/git-kommit", "-m", "Hello"
    assert_match /Hello/, shell_output("#{bin}/git-kommit -s /dev/null 2>&1")
  end
end
