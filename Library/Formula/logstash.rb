class Logstash < Formula
  desc "Tool for managing events and logs"
  homepage "https://www.elastic.co/products/logstash"
  url "https://download.elasticsearch.org/logstash/logstash/logstash-1.5.2.tar.gz"
  sha256 "1d1805d388392a69f5049b35c176186389a7f8bf7347c4528c255edc1f9b0d6a"

  def install
    inreplace %w{bin/logstash}, /^\. "\$\(cd `dirname \$0`\/\.\.; pwd\)\/bin\/logstash\.lib\.sh\"/, ". #{libexec}/bin/logstash.lib.sh"
    inreplace %w{bin/logstash.lib.sh}, /^LOGSTASH_HOME=.*$/, "LOGSTASH_HOME=#{libexec}"
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
    system "/bin/echo 'hello world' | #{bin}/logstash agent -e 'input { stdin { type => stdin } } output { stdout { codec => rubydebug } }'"
  end
end
