class Headphones < Formula
  desc "Automatic music downloader for SABnzbd"
  homepage "https://github.com/rembo10/headphones"
  head "https://github.com/rembo10/headphones.git"
  url "https://github.com/rembo10/headphones/archive/v0.5.2.tar.gz"
  sha256 "d2d5783ea4e2b3dcb77a266be594834c29b5b51adb0e9e718749c8d758a57453"

  bottle do
    cellar :any
    sha256 "0d08693b084d643f0c994c9b3bfa151cbb3b59e7bfeaf7df51c74dc4ca4a65cb" => :yosemite
    sha256 "b9770751fa170bb63dd4ed3eec4d0924bfe5c57344a93689d064b50809d10473" => :mavericks
    sha256 "561f55a8140600eea056c4596a4627d9ce076b24de9daec57cbc2749f8691276" => :mountain_lion
  end

  resource "Markdown" do
    url "https://pypi.python.org/packages/source/M/Markdown/Markdown-2.4.tar.gz"
    sha256 "b8370fce4fbcd6b68b6b36c0fb0f4ec24d6ba37ea22988740f4701536611f1ae"
  end

  resource "Cheetah" do
    url "https://pypi.python.org/packages/source/C/Cheetah/Cheetah-2.4.4.tar.gz"
    sha256 "be308229f0c1e5e5af4f27d7ee06d90bb19e6af3059794e5fd536a6f29a9b550"
  end

  def startup_script; <<-EOS.undent
    #!/bin/bash
    export PYTHONPATH="#{libexec}/lib/python2.7/site-packages:$PYTHONPATH"
    python "#{libexec}/Headphones.py" --datadir="#{etc}/headphones" "$@"
    EOS
  end

  def install
    # TODO: - strip down to the minimal install
    prefix.install_metafiles
    libexec.install Dir["*"]

    ENV["CHEETAH_INSTALL_WITHOUT_SETUPTOOLS"] = "1"
    ENV.prepend_create_path "PYTHONPATH", libexec+"lib/python2.7/site-packages"
    install_args = ["setup.py", "install", "--prefix=#{libexec}"]

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
