class Redpen < Formula
  desc "Proofreading tool to help writers of technical documentation"
  homepage "http://redpen.cc/"
  url "https://github.com/redpen-cc/redpen/releases/download/redpen-1.5.2/redpen-1.5.2.tar.gz"
  sha256 "de1f0f082787a5dd42eb8491e41074d4b06de1a6084762e2977c82a61286348a"

  bottle :unneeded

  depends_on :java => "1.8"

  def install
    # Don't need Windows files.
    rm_f Dir["bin/*.bat"]
    libexec.install %w[conf lib sample-doc js]

    prefix.install "bin"
    bin.env_script_all_files(libexec/"bin", Language::Java.java_home_env("1.8"))
  end

  test do
    path = "#{libexec}/sample-doc/en/sampledoc-en.txt"
    output = "#{bin}/redpen -l 20 -c #{libexec}/conf/redpen-conf-en.xml #{path}"
    assert_match /^sampledoc-en.txt:1: ValidationError[SymbolWithSpace]*/, shell_output(output).split("\n").select { |line| line.start_with?("sampledoc-en.txt") }[0]
  end
end
