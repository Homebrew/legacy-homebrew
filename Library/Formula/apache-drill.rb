class ApacheDrill < Formula
  desc "Schema-free SQL query engine for Hadoop and NoSQL"
  homepage "https://drill.apache.org/download/"
  url "https://www.apache.org/dyn/closer.cgi?path=drill/drill-1.5.0/apache-drill-1.5.0.tar.gz"
  mirror "https://archive.apache.org/dist/drill/drill-1.5.0/apache-drill-1.5.0.tar.gz"
  sha256 "3c7b55b49b449e2acff70798d22868485fadc6678a1500e4416acb8e4903db43"

  bottle :unneeded

  def install
    libexec.install Dir["*"]
    bin.write_exec_script Dir["#{libexec}/bin/*"]
  end

  test do
    ENV.java_cache

    pipe_output("#{bin}/sqlline -u jdbc:drill:zk=local", "!tables", 0)
  end
end
