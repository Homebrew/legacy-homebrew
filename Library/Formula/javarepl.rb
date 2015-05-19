class Javarepl < Formula
  desc "Read Eval Print Loop (REPL) for Java"
  homepage "https://github.com/albertlatacz/java-repl"
  url "https://s3.amazonaws.com/albertlatacz.published/repo/javarepl/javarepl/272/javarepl-272.jar"
  sha256 "f23a2635adee8dee17099a857d4544105ac1bb21d2bb05480162f1c1e0c525fd"

  def install
    libexec.install "javarepl-#{version}.jar"
    bin.write_jar_script libexec/"javarepl-#{version}.jar", "javarepl"
  end

  test do
    assert pipe_output("#{bin}/javarepl", "System.out.println(64*1024)\n:quit\n").include?("65536")
  end
end
