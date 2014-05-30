require 'formula'

class Logstash < Formula
  homepage 'http://logstash.net/'
  url 'https://download.elasticsearch.org/logstash/logstash/logstash-1.4.1.tar.gz'
  sha1 '834599d28ce50012c221ece7a6783c5943221e36'

  def install
    inreplace %w{bin/logstash bin/logstash.lib.sh}, /^basedir=.*$/, "basedir=#{libexec}"
    libexec.install Dir["*"]
    bin.install_symlink libexec/"bin/logstash"
  end

  def caveats; <<-EOS.undent
    Logstash 1.4 emits an unhelpful error if you try to start it sans config.
    Please read the getting started guide located at:
    http://logstash.net/docs/latest/tutorials/getting-started-with-logstash
    EOS
  end

  test do
    system "#{bin}/logstash", "--version"
    system "/bin/echo 'hello world' | #{bin}/logstash agent -e 'input { stdin { type => stdin } } output { stdout { codec => rubydebug } }'"
  end
end
