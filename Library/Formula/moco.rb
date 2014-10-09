require "formula"

class Moco < Formula
  homepage "https://github.com/dreamhead/moco"
  url "http://central.maven.org/maven2/com/github/dreamhead/moco-runner/0.9.2/moco-runner-0.9.2-standalone.jar"
  sha1 "a21445d7b275c48874ed7756477ade74de299e17"

  def install
    libexec.install "moco-runner-0.9.2-standalone.jar"
    bin.write_jar_script libexec/"moco-runner-0.9.2-standalone.jar", "moco"
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
