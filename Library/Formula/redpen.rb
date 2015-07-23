class Redpen < Formula
  desc "Proofreading tool to help writers of technical documentation"
  homepage "http://redpen.cc/"
  url "https://github.com/recruit-tech/redpen/releases/download/v1.3.0/redpen-1.3.0.tar.gz"
  sha256 "3e3aa98fb83acb6c4db96dcc5c44e02fee211dc3edf0fad9cecf1eb374df3e8b"

  depends_on :java => "1.8"

  def install
    # Don't need Windows files.
    rm_f Dir["bin/*.bat"]
    libexec.install %w[conf lib sample-doc]

    prefix.install "bin"
    bin.env_script_all_files(libexec/"bin", Language::Java.java_home_env("1.8"))
  end

  test do
    path = "#{libexec}/sample-doc/en/sampledoc-en.txt"
    output = "#{bin}/redpen -l 20 -c #{libexec}/conf/redpen-conf-en.xml #{path}"
    assert_match /^sampledoc-en.txt:1: ValidationError[SymbolWithSpace]*/, shell_output(output).split("\n").select { |line| line.start_with?("sampledoc-en.txt") }[0]
  end
end
