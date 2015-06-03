class ApacheDrill < Formula
  homepage "https://drill.apache.org/download/"
  url "https://www.apache.org/dyn/closer.cgi?path=drill/drill-1.0.0/apache-drill-1.0.0.tar.gz"
  sha1 "0b43d52f6754bad7c7bb3c36e0dfc4c9de6d71e8"

  def install
    libexec.install Dir["*"]
    bin.write_exec_script Dir["#{libexec}/bin/*"]
  end

  test do
    system "#{bin}/sqlline -u jdbc:drill:zk=local <<< '!tables'"
  end
end
