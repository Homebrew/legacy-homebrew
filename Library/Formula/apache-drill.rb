class ApacheDrill < Formula
  desc "Schema-free SQL query engine for Hadoop and NoSQL"
  homepage "https://drill.apache.org/download/"
  url "https://www.apache.org/dyn/closer.cgi?path=drill/drill-1.4.0/apache-drill-1.4.0.tar.gz"
  mirror "http://getdrill.org/drill/download/apache-drill-1.4.0.tar.gz"
  sha256 "4ffe85865c8e2c453ba0fdb9f701af556836a0293b8d78c214a51ef81f3844ea"

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
