class Filebeat < Formula
  desc "Log data shipper based on Logstash-Forwarder"
  homepage "https://www.elastic.co/guide/en/beats/filebeat/current/index.html"
  url "https://download.elastic.co/beats/filebeat/filebeat-1.1.1-darwin.tgz"
  sha256 "145b3ca979e7890aec1d403d9b27312efd9849720bfaebdf74d249eafbf88830"

  def filebeat_wrapper
    <<-EOS.undent
    #!/usr/bin/env bash
    #{libexec}/filebeat -c #{etc}/filebeat.yml $@
    EOS
  end

  def install
    (bin/"filebeat").write filebeat_wrapper
    chmod 0755, (bin/"filebeat")

    libexec.install "filebeat"
    prefix.install "filebeat.template.json"
    etc.install "filebeat.yml"
  end

  test do
    system "filebeat", "-version"
  end
end
