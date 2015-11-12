class Sickbeard < Formula
  desc "PVR application to search and manage TV shows"
  homepage "http://www.sickbeard.com/"
  head "https://github.com/midgetspy/Sick-Beard.git"
  url "https://github.com/midgetspy/Sick-Beard/archive/build-507.tar.gz"
  sha256 "eaf95ac78e065f6dd8128098158b38674479b721d95d937fe7adb892932e9101"

  bottle do
    sha1 "d144a55f9a667036255b373f7fcf294455d447e2" => :yosemite
    sha1 "2c47e5cec2a12f46f57cff89f29cb34f14b72183" => :mavericks
    sha1 "1a2abb4fcbae529e5c378d5ca75f506c726a8a0b" => :mountain_lion
  end

  resource "Markdown" do
    url "https://pypi.python.org/packages/source/M/Markdown/Markdown-2.4.1.tar.gz"
    sha256 "812ec5249f45edc31330b7fb06e52aaf6ab2d83aa27047df7cb6837ef2d269b6"
  end

  resource "Cheetah" do
    url "https://pypi.python.org/packages/source/C/Cheetah/Cheetah-2.4.4.tar.gz"
    sha256 "be308229f0c1e5e5af4f27d7ee06d90bb19e6af3059794e5fd536a6f29a9b550"
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
