require 'formula'

class Drake < Formula
  desc "Data workflow tool meant to be 'make for data'"
  homepage "https://github.com/Factual/drake"
  head "https://github.com/Factual/drake.git"
  version "v1.0.0"
  url "https://raw.githubusercontent.com/Factual/drake/master/bin/drake-pkg"
  sha256 "8e09238f7f9e18fe5eaade60d461801f47bfb29fbbefec951075683c2b0ace49"

  resource "jar" do
    url "https://github.com/Factual/drake/releases/download/v1.0.0/drake.jar"
    sha256 "f601f059dd23f87ccb1fa9ce1c39067e8bbeed36f08820769c6132c311e99aa8"
  end

  def install
    jar = "drake-#{version}-standalone.jar"
    inreplace "drake-pkg", /DRAKE_JAR/, lib/jar
    bin.install "drake-pkg" => "drake"
    resource("jar").stage do
      lib.install "drake.jar" => jar
    end
  end

  test do
    # count lines test
    (testpath/'Drakefile').write <<-EOS.undent
      find_lines <- [shell]
        echo 'drake' > $OUTPUT

      count_drakes_lines <- find_lines
        cat $INPUT | wc -l > $OUTPUT
    EOS

    # force run (no user prompt) the full workflow
    system bin/"drake", "--auto", "--workflow=#{testpath}/Drakefile", "+..."
  end
end
