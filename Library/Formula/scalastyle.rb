class Scalastyle < Formula
  desc "Run scalastyle from the command-line"
  homepage "http://www.scalastyle.org/command-line.html"
  url "https://oss.sonatype.org/content/repositories/releases/org/scalastyle/scalastyle_2.11/0.7.0/scalastyle_2.11-0.7.0-batch.jar"
  sha256 "3f61e6f03615019068ad79a8d70890a0af893650c98009b1c4acb73a0b8341ba"

  bottle :unneeded

  resource "default_config" do
    url "https://raw.githubusercontent.com/scalastyle/scalastyle/v0.7.0/lib/scalastyle_config.xml"
    version "0.7.0"
    sha256 "80e7d2324e5cae9bd479d19134488b129c661e0489a8877a31e6f36b333c5f78"
  end

  def install
    libexec.install "scalastyle_2.11-#{version}-batch.jar"
    etc.install resource("default_config")

    (bin/"scalastyle").write <<-EOS.undent
      #!/bin/sh
      java -jar "#{libexec}/scalastyle_2.11-#{version}-batch.jar" --config "#{etc}/scalastyle_config.xml" "$@"
    EOS
  end

  def caveats
    <<-EOS.undent
      A default configuration file is used from "#{etc}/scalastyle_config.xml"
      To override, pass a "--config your_config.xml" argument on the command line.
    EOS
  end

  test do
    (testpath/"test.scala").write <<-EOS.undent
      object HelloWorld {
        def main(args: Array[String]) {
          println("Hello")
        }
      }
    EOS
    system bin/"scalastyle", testpath/"test.scala"
  end
end
