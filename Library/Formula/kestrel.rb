class Kestrel < Formula
  desc "Distributed message queue"
  homepage "https://twitter.github.io/kestrel/"
  url "https://twitter.github.io/kestrel/download/kestrel-2.4.1.zip"
  sha256 "5d72a301737cc6cc3908483ce73d4bdb6e96521f3f8c96f93b732d740aaea80c"

  bottle :unneeded

  def install
    inreplace "scripts/kestrel.sh" do |s|
      s.change_make_var! "APP_HOME", libexec

      # Fix var paths.
      s.gsub! "/var/", "/#{var}/"

      # Fix path to script in help message.
      s.gsub! "Usage: /etc/init.d/${APP_NAME}.sh", "Usage: kestrel"

      # Don't call ulimit as not root.
      s.gsub! "ulimit -", "# ulimit -"
    end

    inreplace "config/production.scala" do |s|
      # Fix var paths.
      s.gsub! "/var/", "/#{var}/"
    end

    libexec.install Dir["*"]
    (libexec/"scripts/kestrel.sh").chmod 0755
    (libexec/"scripts/devel.sh").chmod 0755

    (var/"log/kestrel").mkpath
    (var/"run/kestrel").mkpath
    (var/"spool/kestrel").mkpath

    (bin/"kestrel").write <<-EOS.undent
      #!/bin/bash
      exec "#{libexec}/scripts/kestrel.sh" "$@"
    EOS
  end

  test do
    system "#{bin}/kestrel", "status"
  end
end
