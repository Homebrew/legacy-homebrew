require "formula"

class Sickbeard < Formula
  homepage "http://www.sickbeard.com/"
  head "https://github.com/midgetspy/Sick-Beard.git"
  url "https://github.com/midgetspy/Sick-Beard/archive/build-505.tar.gz"
  sha1 "ac49ccb36451958e00d842cb89caf55f2fcd45f8"

  bottle do
    sha1 "2b0f341d4c6f8b0392b59fe6216d2c35e9975ed0" => :mavericks
    sha1 "bbaa31a3f83779ff2f8bd0eb84e5005c35ca8f5a" => :mountain_lion
    sha1 "4dd86fff9ef46a4d58c12eb4ffce0254baedd4f9" => :lion
  end

  resource "Markdown" do
    url "https://pypi.python.org/packages/source/M/Markdown/Markdown-2.4.tar.gz"
    sha1 "7a4a96cd79c4e36918484c634055c4cc27bdf7d4"
  end

  resource "Cheetah" do
    url "https://pypi.python.org/packages/source/C/Cheetah/Cheetah-2.4.4.tar.gz"
    sha1 "c218f5d8bc97b39497680f6be9b7bd093f696e89"
  end

  def install
    # TODO - strip down to the minimal install
    prefix.install_metafiles
    libexec.install Dir["*"]

    ENV["CHEETAH_INSTALL_WITHOUT_SETUPTOOLS"] = "1"
    ENV.prepend_create_path "PYTHONPATH", libexec+"lib/python2.7/site-packages"
    install_args = [ "setup.py", "install", "--prefix=#{libexec}" ]

    resource("Markdown").stage { system "python", *install_args }
    resource("Cheetah").stage { system "python", *install_args }

    (bin+"sickbeard").write(startup_script)
  end

  plist_options :manual => "sickbeard"

  def plist; <<-EOS.undent
    <?xml version="1.0" encoding="UTF-8"?>
    <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
    <plist version="1.0">
    <dict>
      <key>Label</key>
      <string>#{plist_name}</string>
      <key>ProgramArguments</key>
      <array>
        <string>#{opt_bin}/sickbeard</string>
        <string>-q</string>
        <string>--nolaunch</string>
        <string>-p</string>
        <string>8081</string>
      </array>
      <key>RunAtLoad</key>
      <true/>
    </dict>
    </plist>
    EOS
  end

  def startup_script; <<-EOS.undent
    #!/bin/bash
    export PYTHONPATH="#{libexec}/lib/python2.7/site-packages:$PYTHONPATH"
    python "#{libexec}/SickBeard.py"\
           "--pidfile=#{var}/run/sickbeard.pid"\
           "--datadir=#{etc}/sickbeard"\
           "$@"
    EOS
  end

  def caveats
    "SickBeard defaults to port 8081."
  end
end
