class Sickrage < Formula
  homepage "http://www.sickrage.tv/"
  head "https://github.com/SiCKRAGETV/SickRage.git"
  url "https://github.com/SiCKRAGETV/SickRage/archive/v4.0.17.tar.gz"
  version "4.0.17"
  sha256 "cc24da6b80068cee5878885e1365309ae57c191ae474da4cc9fa93a2e5bc3a78"

  depends_on :python if MacOS.version <= :snow_leopard

  resource "cheetah" do
    url "https://pypi.python.org/packages/source/C/Cheetah/Cheetah-2.4.4.tar.gz"
    sha256 "be308229f0c1e5e5af4f27d7ee06d90bb19e6af3059794e5fd536a6f29a9b550"
  end

  def install
    libexec.install Dir["*"]

    resource("cheetah").stage do
      system "python", *Language::Python.setup_install_args(libexec/"vendor")
    end

    (bin/"sickrage").write(startup_script)
  end

  def caveats
    "SickRage defaults to port 8081."
  end

  plist_options :manual => "sickrage"

  def plist; <<-EOS.undent
    <?xml version="1.0" encoding="UTF-8"?>
    <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
    <plist version="1.0">
    <dict>
      <key>Label</key>
      <string>#{plist_name}</string>
      <key>RunAtLoad</key>
      <true/>
      <key>ProgramArguments</key>
      <array>
        <string>#{opt_bin}/sickrage</string>
        <string>-q</string>
        <string>--nolaunch</string>
        <string>-p</string>
        <string>8081</string>
      </array>
    </dict>
    </plist>
    EOS
  end

  def startup_script; <<-EOS.undent
    #!/bin/bash
    export PYTHONPATH="#{libexec}/vendor/lib/python2.7/site-packages:$PYTHONPATH"
    python "#{libexec}/SickBeard.py"\
      "--pidfile=#{var}/run/sickrage.pid"\
      "--datadir=#{etc}/sickrage"\
      "$@"
    EOS
  end
end
