require 'formula'

class Drake < Formula
  desc "Data workflow tool meant to be 'make for data'"
  homepage "https://github.com/Factual/drake"
  head "https://github.com/Factual/drake.git"
  version "v1.0.0"
  url "https://raw.githubusercontent.com/Factual/drake/master/bin/drake-pkg"
  sha1 "3791f8e681620dae927bc70e22452b2703402724"

  resource "jar" do
    url "https://github.com/Factual/drake/releases/download/v1.0.0/drake.jar"
    sha1 "0ee261ba884c6bf2572d99b0c2bbf943b4da8da0"
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
