class SpoofMac < Formula
  desc "Spoof your MAC address in OS X"
  homepage "https://github.com/feross/SpoofMAC"
  url "https://pypi.python.org/packages/source/S/SpoofMAC/SpoofMAC-2.1.0.tar.gz"
  sha256 "02a6a1eaed85d0e2be52299db29cbc517f60d41eeca9897eff3d5bb1ca14f3ab"
  head "https://github.com/feross/SpoofMAC.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "d592a380857fdc31367073b2c872b3c5d6a06ded014cb494b7df6f6d9ae492cb" => :el_capitan
    sha256 "fb321fd4581be3338316436e0e95ede2f6c869e2dd29133a134449e771aaf594" => :yosemite
    sha256 "cd40c73828b74692db833fad3097a4377f83f6b236599470c702fc371bbdbe51" => :mavericks
  end

  depends_on :python if MacOS.version <= :snow_leopard

  resource "docopt" do
    url "https://pypi.python.org/packages/source/d/docopt/docopt-0.6.2.tar.gz"
    sha256 "49b3a825280bd66b3aa83585ef59c4a8c82f2c8a522dbe754a8bc8d08c85c491"
  end

  def install
    ENV["PYTHONPATH"] = libexec/"lib/python2.7/site-packages"
    ENV.prepend_create_path "PYTHONPATH", libexec/"vendor/lib/python2.7/site-packages"

    resources.each do |r|
      r.stage { system "python", *Language::Python.setup_install_args(libexec/"vendor") }
    end

    system "python", *Language::Python.setup_install_args(libexec)

    bin.install_symlink "spoof-mac.py" => "spoof-mac"
    bin.env_script_all_files(libexec+"bin", :PYTHONPATH => ENV["PYTHONPATH"])
  end

  plist_options :startup => true, :manual => "spoof-mac"

  def plist; <<-EOS.undent
    <?xml version="1.0" encoding="UTF-8"?>
    <!DOCTYPE plist PUBLIC "-//Apple Computer//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
    <plist version="1.0">
      <dict>
        <key>Label</key>
        <string>#{plist_name}</string>
        <key>ProgramArguments</key>
        <array>
          <string>#{opt_bin}/spoof-mac</string>
          <string>randomize</string>
          <string>en0</string>
        </array>
        <key>RunAtLoad</key>
        <true/>
        <key>StandardErrorPath</key>
        <string>/dev/null</string>
        <key>StandardOutPath</key>
        <string>/dev/null</string>
      </dict>
    </plist>
    EOS
  end

  def caveats; <<-EOS.undent
    Although spoof-mac can run without root, you must be root to change the MAC.

    The launchdaemon is set to randomize en0.
    You can find the interfaces available by running:
        "spoof-mac list"

    If you wish to change interface randomized at startup change the plist line:
        <string>en0</string>
    to e.g.:
        <string>en1</string>
    EOS
  end

  test do
    system "#{bin}/spoof-mac", "list", "--wifi"
  end
end
