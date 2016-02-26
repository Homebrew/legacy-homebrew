class Yeti < Formula
  desc "ML-style functional programming language that runs on the JVM"
  homepage "https://mth.github.io/yeti/"
  url "https://github.com/mth/yeti/archive/v0.9.9.1.tar.gz"
  sha256 "c552018993570724313fc0624d225e266cd95e993d121850b34aa706f04e3dfe"

  head "https://github.com/mth/yeti.git"

  depends_on :ant => :build
  depends_on :java => "1.8"

  def install
    system "ant", "jar"
    libexec.install "yeti.jar"
    bin.write_jar_script libexec/"yeti.jar", "yeti", "-server"
  end

  test do
    assert_equal "3\n", shell_output("#{bin}/yeti -e 'do x: x+1 done 2'")
  end
end
