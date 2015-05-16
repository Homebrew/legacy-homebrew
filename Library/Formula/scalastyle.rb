class Scalastyle < Formula
  homepage "http://www.scalastyle.org/command-line.html"
  url "https://oss.sonatype.org/content/repositories/releases/org/scalastyle/scalastyle_2.10/0.6.0/scalastyle_2.10-0.6.0-batch.jar"
  sha1 "01c744fa7eef25f7183beea5d603ce9658861fcf"

  resource "default_config" do
    url "https://raw.githubusercontent.com/scalastyle/scalastyle/v0.6.0/lib/scalastyle_config.xml"
    version "0.6.0"
    sha1 "c22165ccda7ef285665041ad07a4b31a639a85c3"
  end

  def install
    libexec.install "scalastyle_2.10-#{version}-batch.jar"

    etc.install resource("default_config")

    (bin/"scalastyle").write <<-EOS.undent
      #!/bin/sh
      java -jar "#{libexec}/scalastyle_2.10-#{version}-batch.jar" --config "#{etc}/scalastyle_config.xml" "$@"
    EOS
  end

  def caveats
    <<-EOS.undent
      A default configuration file is used from "#{etc}/scalastyle_config.xml"
      To override, pass a "--config your_config.xml" argument on the command line.
    EOS
  end

  test do
    system bin/"scalastyle", "--verbose"
  end
end
