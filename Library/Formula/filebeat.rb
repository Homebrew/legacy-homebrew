class Filebeat < Formula
  desc "Log data shipper based on Logstash-Forwarder"
  homepage "https://www.elastic.co/guide/en/beats/filebeat/current/index.html"
  url "https://github.com/elastic/beats/archive/v1.1.1.tar.gz"
  sha256 "5cf4751e6cd5199e6cef5b9d86ef62923901e659f4f15c70a4a9e007c32c4eb5"

  depends_on "go"

  def install
    ENV["GOPATH"] = buildpath
    mkdir_p buildpath/"src/github.com/elastic/"
    ln_sf buildpath, buildpath/"src/github.com/elastic/beats"

    cd "src/github.com/elastic/beats/filebeat" do
      system "make", "build"
      libexec.install "filebeat"
      pkgshare.install "etc/filebeat.template.json"
      etc.install "etc/filebeat.yml"
    end

    (bin/"filebeat").write <<-EOS.undent
    #!/usr/bin/env bash
    #{libexec}/filebeat -c #{etc}/filebeat.yml $@
    EOS
    chmod 0755, bin/"filebeat"
  end

  test do
    system bin/"filebeat", "-version"
  end
end
