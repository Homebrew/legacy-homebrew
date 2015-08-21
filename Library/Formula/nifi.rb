class Nifi < Formula
  desc "Easy to use, powerful, and reliable system to process and distribute data."
  homepage "https://nifi.apache.org"
  url "https://www.apache.org/dyn/closer.cgi?path=/nifi/0.2.1/nifi-0.2.1-bin.tar.gz"
  sha256 "e151dab553a8ea466f7462d75145e2aa08ced938499aef184850aa4d3209c605"

  depends_on :java => "1.7+"

  # Wrap our nifi executable to point to the appropriate location within the brew environment
  def script; <<-EOS.undent
    #!/bin/sh
    export NIFI_HOME="#{libexec}"
    exec "#{libexec}/bin/nifi.sh" "$@"
    EOS
  end

  def install
    libexec.install Dir["*"]
    (bin/"nifi").write script
  end

  test do
    system "nifi", "status"
  end
end
