class Logstash < Formula
  desc "Tool for managing events and logs"
  homepage "https://www.elastic.co/products/logstash"
  url "https://download.elastic.co/logstash/logstash/logstash-2.1.0.tar.gz"
  sha256 "1f132e0fc9fc46ebe836951bb44c5cd1a5f8e3f653bb44bded55300cc6c892dc"

  bottle :unneeded

  head do
    url "https://github.com/elastic/logstash.git"
    depends_on :java => "1.8"
  end

  depends_on :java => "1.7+"

  def install
    if build.head?
      # Build the package from source
      system "rake", "artifact:tar"
      # Extract the package to the current directory
      targz = Dir["build/logstash-*.tar.gz"].first
      system "tar", "-xf", targz
    end

    inreplace %w[bin/logstash], %r{^\. "\$\(cd `dirname \$0`\/\.\.; pwd\)\/bin\/logstash\.lib\.sh\"}, ". #{libexec}/bin/logstash.lib.sh"
    inreplace %w[bin/logstash.lib.sh], /^LOGSTASH_HOME=.*$/, "LOGSTASH_HOME=#{libexec}"
    libexec.install Dir["*"]
    bin.install_symlink libexec/"bin/logstash"
  end

  def caveats; <<-EOS.undent
    Please read the getting started guide located at:
      https://www.elastic.co/guide/en/logstash/current/getting-started-with-logstash.html
    EOS
  end

  test do
    (testpath/"simple.conf").write <<-EOS.undent
      input { stdin { type => stdin } }
      output { stdout { codec => rubydebug } }
    EOS

    output = pipe_output("/bin/echo 'hello world' | #{bin}/logstash -f simple.conf")
    assert_match /hello world/, output
  end
end
