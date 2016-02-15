class Moco < Formula
  desc "Stub server with Maven, Gradle, Scala, and shell integration"
  homepage "https://github.com/dreamhead/moco"
  url "https://search.maven.org/remotecontent?filepath=com/github/dreamhead/moco-runner/0.10.2/moco-runner-0.10.2-standalone.jar"
  version "0.10.2"
  sha256 "ef946d090d3108843708c194809c57f192e3623dbbbcf86bdee54ce93c299a41"

  bottle :unneeded

  def install
    libexec.install "moco-runner-0.10.2-standalone.jar"
    bin.write_jar_script libexec/"moco-runner-0.10.2-standalone.jar", "moco"
  end

  test do
    require "net/http"

    (testpath/"config.json").write <<-EOS.undent
      [
        {
          "response" :
          {
              "text" : "Hello, Moco"
          }
        }
    ]
    EOS

    port = 12306
    thread = Thread.new do
      system bin/"moco", "start", "-p", port, "-c", testpath/"config.json"
    end

    # Wait for Moco to start.
    sleep 5

    response = Net::HTTP.get URI "http://localhost:#{port}"
    assert_equal "Hello, Moco", response
    thread.exit
  end
end
