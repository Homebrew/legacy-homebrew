class Javarepl < Formula
  desc "Read Eval Print Loop (REPL) for Java"
  homepage "https://github.com/albertlatacz/java-repl"
  url "https://s3.amazonaws.com/albertlatacz.published/repo/javarepl/javarepl/282/javarepl-282.jar"
  sha256 "7e53bd10ff9395e3114ed10a65b5bfbe0e7280a0d67620787e330244e7f26644"

  def install
    libexec.install "javarepl-#{version}.jar"
    bin.write_jar_script libexec/"javarepl-#{version}.jar", "javarepl"
  end

  test do
    assert pipe_output("#{bin}/javarepl", "System.out.println(64*1024)\n:quit\n").include?("65536")
  end
end
