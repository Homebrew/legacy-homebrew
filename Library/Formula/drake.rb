class Drake < Formula
  desc "Data workflow tool meant to be 'make for data'"
  homepage "https://github.com/Factual/drake"
  url "https://raw.githubusercontent.com/Factual/drake/1.0.0/bin/drake-pkg"
  version "1.0.0"
  sha256 "6b75504f85f01a7d213c60f87e7da0d94a4961bbc7e9b7e90f79efcc38ae5165"
  head "https://github.com/Factual/drake.git"

  bottle do
    cellar :any
    sha256 "0e1d17ad42bb1bd51792aa625664f1d1fb12748ac2f1783a53da4c6e6ba74124" => :yosemite
    sha256 "7f1113ff253e4dccb34f54ff710da37738d39ce60fe014a97103af38a848fdb8" => :mavericks
    sha256 "9b83197b887b6ce5f7912afbebcad3dff4c550b4057b45673d826982f94e481f" => :mountain_lion
  end

  resource "jar" do
    url "https://github.com/Factual/drake/releases/download/1.0.0/drake.jar"
    sha256 "f601f059dd23f87ccb1fa9ce1c39067e8bbeed36f08820769c6132c311e99aa8"
  end

  def install
    jar = "drake-#{version}-standalone.jar"
    inreplace "drake-pkg", /DRAKE_JAR/, libexec/jar
    bin.install "drake-pkg" => "drake"
    resource("jar").stage do
      libexec.install "drake.jar" => jar
    end
  end

  test do
    # count lines test
    (testpath/"Drakefile").write <<-EOS.undent
      find_lines <- [shell]
        echo 'drake' > $OUTPUT

      count_drakes_lines <- find_lines
        cat $INPUT | wc -l > $OUTPUT
    EOS

    # force run (no user prompt) the full workflow
    system bin/"drake", "--auto", "--workflow=#{testpath}/Drakefile", "+..."
  end
end
