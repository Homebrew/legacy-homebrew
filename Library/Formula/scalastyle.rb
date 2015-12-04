class Scalastyle < Formula
  desc "Run scalastyle from the command-line"
  homepage "http://www.scalastyle.org/command-line.html"
  url "https://oss.sonatype.org/content/repositories/releases/org/scalastyle/scalastyle_2.11/0.8.0/scalastyle_2.11-0.8.0-batch.jar"
  sha256 "0f902a6d8c3f7bedb87860fc236bbd65deb801ea2a4d703b8f3a6475e9aea531"

  bottle :unneeded

  resource "default_config" do
    url "https://raw.githubusercontent.com/scalastyle/scalastyle/v0.8.0/lib/scalastyle_config.xml"
    version "0.8.0"
    sha256 "feb61c4a09373717f94d277487e8118be524bb4c3265eb6d2fdee7a1fa362e50"
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
