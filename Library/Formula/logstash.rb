require 'formula'

class Logstash < Formula
  homepage 'http://logstash.net/'
  url 'https://download.elasticsearch.org/logstash/logstash/logstash-1.5.0.tar.gz'
  sha1 '9729c2d31fddaabdd3d8e94c34a6d1f61d57f94a'

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
