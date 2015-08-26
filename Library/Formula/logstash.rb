class Logstash < Formula
  desc "Tool for managing events and logs"
  homepage "https://www.elastic.co/products/logstash"
  url "https://download.elastic.co/logstash/logstash/logstash-1.5.4.tar.gz"
  sha256 "f03075ee534ce6e7667679447f56543ce05cebbdb7b65a9396a5e538bf3e9fa8"

  depends_on :java => "1.7+"

  def install
    inreplace %w[bin/logstash], %r{^\. "\$\(cd `dirname \$0`\/\.\.; pwd\)\/bin\/logstash\.lib\.sh\"}, ". #{libexec}/bin/logstash.lib.sh"
    inreplace %w[bin/logstash.lib.sh], /^LOGSTASH_HOME=.*$/, "LOGSTASH_HOME=#{libexec}"
    libexec.install Dir["*"]
    bin.install_symlink libexec/"bin/logstash"
  end

  def caveats; <<-EOS.undent
    Logstash 1.5 emits an unhelpful error if you try to start it without config.
    Please read the getting started guide located at:
      https://www.elastic.co/guide/en/logstash/current/getting-started-with-logstash.html
    EOS
  end

  test do
    (testpath/"simple.conf").write <<-EOS.undent
      input { stdin { type => stdin } }
      output { stdout { codec => rubydebug } }
    EOS

    output = pipe_output("/bin/echo 'hello world' | #{bin}/logstash agent -f simple.conf")
    assert_match /hello world/, output
  end
end
