require "formula"

class Eventstore < Formula
  homepage "http://geteventstore.com"
  url "http://download.geteventstore.com/binaries/EventStore-OSS-Mac-v3.0.0.tar.gz"
  sha1 "4120470a5a8acbfd7d483318fd67d4a1f1648a8e"

  depends_on :macos => :mavericks

  def install
    prefix.install Dir["*"]

    (bin/"eventstore").write <<-EOS.undent
      #!/bin/sh
      cd "#{prefix}"
      exec "#{prefix}/clusternode" "$@"
      EOS

    (bin/"eventstore-testclient").write <<-EOS.undent
      #!/bin/sh
      exec "#{prefix}/testclient" "$@"
      EOS
  end

  test do
    system "#{bin}/eventstore --version"
  end
end
