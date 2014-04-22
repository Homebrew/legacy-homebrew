require 'formula'

class Logstash < Formula
  homepage 'http://logstash.net/'
  url 'https://download.elasticsearch.org/logstash/logstash/logstash-1.4.0.tar.gz'
  sha1 '009c9d3d17b781b6ad2cceb776064cda6c6b3957'
  head 'https://github.com/elasticsearch/logstash.git', :using => :git

  def install
    inreplace "bin/logstash", /^basedir=.*$/, "basedir=#{prefix}"
    inreplace "bin/logstash.lib.sh", /^basedir=.*$/, "basedir=#{prefix}"
    prefix.install Dir["*"]
  end

  test do
    system "#{bin}/logstash", "--version"
  end
end
