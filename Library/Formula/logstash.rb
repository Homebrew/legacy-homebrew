require 'formula'

class Logstash < Formula
  desc "Tool for managing events and logs"
  homepage 'https://www.elastic.co/products/logstash'
  url 'https://download.elasticsearch.org/logstash/logstash/logstash-1.5.0.tar.gz'
  sha256 '8e073ee4c0dd346c62d538d3f28c95e536b9d3f269d0f993cff8662d799163d3'

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
