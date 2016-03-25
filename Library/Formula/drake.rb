class Drake < Formula
  desc "Data workflow tool meant to be 'make for data'"
  homepage "https://github.com/Factual/drake"
  url "https://raw.githubusercontent.com/Factual/drake/1.0.1/bin/drake-pkg"
  version "1.0.1"
  sha256 "adeb0bb14dbe39789273c5c766da9a019870f2a491ba1f0c8c328bd9a95711cc"
  head "https://github.com/Factual/drake.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "f07b00f62d054877ab1d4084cc6e6aed22c619d601422c9c6410eb08dd581c26" => :el_capitan
    sha256 "e4ee3af345696cf803595939d098879912dae3e6ba2527609ebd53b6d0f1eae3" => :yosemite
    sha256 "aecf20701580e0bf885180114d019b0892f9ee108da60a8aba5bc119897a9d13" => :mavericks
    sha256 "70caad1ee5b8f61aaa9cd62f5ff3f4bd456b4e2fc9a6309c127a45cee4375c76" => :mountain_lion
  end

  resource "jar" do
    url "https://github.com/Factual/drake/releases/download/1.0.1/drake.jar"
    sha256 "2d4350fe00c3a591900ab74d3155019fa4d1f1f70559600e3651909ce4d4f2f6"
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
