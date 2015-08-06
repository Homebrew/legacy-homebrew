class ApacheDrill < Formula
  desc "Schema-free SQL query engine for Hadoop and NoSQL"
  homepage "https://drill.apache.org/download/"
  url "https://www.apache.org/dyn/closer.cgi?path=drill/drill-1.1.0/apache-drill-1.1.0.tar.gz"
  mirror "http://getdrill.org/drill/download/apache-drill-1.1.0.tar.gz"
  sha256 "04b6b21eb526f0491050a432f7d2bbea77d0bf231ac404843840c604310a41d2"

  def install
    libexec.install Dir["*"]
    bin.write_exec_script Dir["#{libexec}/bin/*"]
  end

  test do
    pipe_output("#{bin}/sqlline -u jdbc:drill:zk=local", "!tables", 0)
  end
end
