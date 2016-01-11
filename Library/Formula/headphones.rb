class Headphones < Formula
  desc "Automatic music downloader for SABnzbd"
  homepage "https://github.com/rembo10/headphones"
  head "https://github.com/rembo10/headphones.git"
  url "https://github.com/rembo10/headphones/archive/v0.5.9.tar.gz"
  sha256 "c1811985ac93a7a24fc0668bb4a726a663e815b7f1a90eb52bf5af60f035c953"

  bottle do
    cellar :any_skip_relocation
    sha256 "a7ec802ae3b408718f32e486d0acd99cccbdfa6323637f909d522d02c50714c6" => :el_capitan
    sha256 "f3e510b4e855350ab24ee1fc463438df3c9273e52ec6f047cf0ecd228f23dfd6" => :yosemite
    sha256 "6e66ba50f949f45d295d5cd75e4240a893c4d564f2522ca9c3985298c14181b8" => :mavericks
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
