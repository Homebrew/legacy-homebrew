class ApacheDrill < Formula
  desc "Schema-free SQL query engine for Hadoop and NoSQL"
  homepage "https://drill.apache.org/download/"
  url "https://www.apache.org/dyn/closer.cgi?path=drill/drill-1.2.0/apache-drill-1.2.0.tar.gz"
  mirror "http://getdrill.org/drill/download/apache-drill-1.2.0.tar.gz"
  sha256 "81e1b6e41efa9340ad45c18e6db6c5dcb14eef4fecc8959fc6ac328083e6182a"

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
