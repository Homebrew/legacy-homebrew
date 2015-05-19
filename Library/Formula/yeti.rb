class Yeti < Formula
  desc "ML-style functional programming language that runs on the JVM"
  homepage "https://mth.github.io/yeti/"
  url "https://github.com/mth/yeti/archive/v0.9.9.tar.gz"
  sha1 "d4b3fee9e9e1c117f1a73b147695a24a217c2658"

  head "https://github.com/mth/yeti.git"

  depends_on :ant => :build
  depends_on :java => "1.7"

  def install
    system "ant", "jar"
    libexec.install "yeti.jar"
    bin.write_jar_script libexec/"yeti.jar", "yeti", "-server"
  end

  test do
    assert_equal "3\n", shell_output("#{bin}/yeti -e 'do x: x+1 done 2'")
  end
end
