class Javarepl < Formula
  desc "Read Eval Print Loop (REPL) for Java"
  homepage "https://github.com/albertlatacz/java-repl"
  url "https://s3.amazonaws.com/albertlatacz.published/repo/javarepl/javarepl/282/javarepl-282.jar"
  sha256 "7e53bd10ff9395e3114ed10a65b5bfbe0e7280a0d67620787e330244e7f26644"

  bottle do
    cellar :any
    sha256 "68d447e17b9d3aedef0ca0416b089c93155105894fc737947546c69e830e57d2" => :yosemite
    sha256 "b994f2504b01a392c914357087dfd0aaf5b8e6a653b42386220ffcee1f29bf6e" => :mavericks
    sha256 "641690079299271cd51623cf6bc0e8e6b786aa0f984e240a78e248d3129cf893" => :mountain_lion
  end

  def install
    libexec.install "javarepl-#{version}.jar"
    bin.write_jar_script libexec/"javarepl-#{version}.jar", "javarepl"
  end

  test do
    assert pipe_output("#{bin}/javarepl", "System.out.println(64*1024)\n:quit\n").include?("65536")
  end
end
