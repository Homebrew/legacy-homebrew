class Headphones < Formula
  desc "Automatic music downloader for SABnzbd"
  homepage "https://github.com/rembo10/headphones"
  head "https://github.com/rembo10/headphones.git"
  url "https://github.com/rembo10/headphones/archive/v0.5.2.tar.gz"
  sha1 "299ec2265a6f362b777712d945b1dff98fc02bf7"

  bottle do
    cellar :any
    sha256 "0d08693b084d643f0c994c9b3bfa151cbb3b59e7bfeaf7df51c74dc4ca4a65cb" => :yosemite
    sha256 "b9770751fa170bb63dd4ed3eec4d0924bfe5c57344a93689d064b50809d10473" => :mavericks
    sha256 "561f55a8140600eea056c4596a4627d9ce076b24de9daec57cbc2749f8691276" => :mountain_lion
  end

  resource "Markdown" do
    url "https://pypi.python.org/packages/source/M/Markdown/Markdown-2.4.tar.gz"
    sha1 "7a4a96cd79c4e36918484c634055c4cc27bdf7d4"
  end

  resource "Cheetah" do
    url "https://pypi.python.org/packages/source/C/Cheetah/Cheetah-2.4.4.tar.gz"
    sha1 "c218f5d8bc97b39497680f6be9b7bd093f696e89"
  end

  def startup_script; <<-EOS.undent
    #!/bin/bash
    export PYTHONPATH="#{libexec}/lib/python2.7/site-packages:$PYTHONPATH"
    python "#{libexec}/Headphones.py" --datadir="#{etc}/headphones" "$@"
    EOS
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

    (bin+"headphones").write(startup_script)
  end

  plist_options :manual => "headphones"

  def plist; <<-EOS.undent
    <?xml version="1.0" encoding="UTF-8"?>
    <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
    <plist version="1.0">
    <dict>
      <key>Label</key>
      <string>#{plist_name}</string>
      <key>ProgramArguments</key>
      <array>
        <string>#{opt_bin}/headphones</string>
        <string>-q</string>
        <string>-d</string>
        <string>--nolaunch</string>
      </array>
      <key>RunAtLoad</key>
      <true/>
    </dict>
    </plist>
    EOS
  end

  def caveats
    "Headphones defaults to port 8181."
  end
end
