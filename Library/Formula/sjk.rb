class Sjk < Formula
  desc "Swiss Java Knife"
  homepage "https://github.com/aragozin/jvm-tools"
  url "https://bintray.com/artifact/download/aragozin/generic/sjk-plus-0.3.6.jar"
  sha256 "9420403139c1b843320fe07bac56f704b0d13715d53b5b2b5869d32103a99a47"

  depends_on :java

  resource "shell_wrapper" do
    url "https://gist.githubusercontent.com/dennisoelkers/2bda4937ab823ea54d44/raw/87af0aa7510afea4022a0296f2c93cc1c0a2bee0/sjk.sh"
    sha256 "42ecaa01e781553c36526485efc9702c9c2138c948f328513e22e06a74962007"
  end

  def install
    lib.install "sjk-plus-0.3.6.jar"
    resource("shell_wrapper").stage { bin.install "sjk.sh" => "sjk" }
  end

  test do
    system "#{bin}/sjk", "jps"
  end
end
