class Ccat < Formula
  homepage "https://github.com/jingweno/ccat"
  url "https://github.com/jingweno/ccat/archive/v0.1.0.tar.gz"
  sha256 "437c7582ab39c8a1fb5e97ae9569e0096c98209a2ebb11ca67a7f9246b129c7c"

  depends_on "go" => :build

  def install
    system "./script/build"
    bin.install "ccat"
  end

  test do
    (testpath/"test.txt").write <<-EOS.undent
      I am a colourful cat
    EOS

    assert_match(/I am a colourful cat/, shell_output("#{bin}/ccat test.txt"))
  end
end
