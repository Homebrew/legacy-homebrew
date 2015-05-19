class ApacheDrill < Formula
  desc "Schema-free SQL query engine for Hadoop and NoSQL"
  homepage "https://drill.apache.org/download/"
  url "https://www.apache.org/dyn/closer.cgi?path=drill/drill-1.0.0/apache-drill-1.0.0.tar.gz"
  sha256 "59f293aeb61ff55e3ab280dc3fbc9648dd6c1aefa2282a5a772be11d4f5a2682"

  def install
    libexec.install Dir["*"]
    bin.write_exec_script Dir["#{libexec}/bin/*"]
  end

  test do
    pipe_output("#{bin}/sqlline -u jdbc:drill:zk=local", "!tables", 0)
  end
end
