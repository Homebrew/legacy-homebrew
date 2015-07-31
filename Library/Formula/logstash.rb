class Logstash < Formula
  desc "Tool for managing events and logs"
  homepage "https://www.elastic.co/products/logstash"
  url "https://download.elasticsearch.org/logstash/logstash/logstash-1.5.3.tar.gz"
  sha256 "eb3c366074e561d777348bfe9db3d4d1cccbf2fa8e7406776f500b4ca639c4aa"

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
    system "#{bin}/logstash", "--version"
    system "/bin/echo", "'hello world' | #{bin}/logstash agent -e 'input { stdin { type => stdin } } output { stdout { codec => rubydebug } }'"
  end
end
