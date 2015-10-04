class SpoofMac < Formula
  desc "Spoof your MAC address in OS X"
  homepage "https://github.com/feross/SpoofMAC"
  url "https://pypi.python.org/packages/source/S/SpoofMAC/SpoofMAC-2.0.5.tar.gz"
  sha256 "16576c5197d2abf728ebad282f94872c7c79d2a65693b72a1644b69414814134"

  head "https://github.com/feross/SpoofMAC.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "2f0e7ca8855c7132908fd6c15e021e77dca318f6c95e9272e823a446fde19af7" => :el_capitan
    sha256 "f4b4c37c0bb9995e1b3ee43801e063c042ba651fa4b7f746d7c14ae18ef5692d" => :yosemite
    sha256 "91dbb7c621dbb6d64fd8d9e9571185a01c41b89d13d5793c2f626948a8abb6f7" => :mavericks
    sha256 "c13d7a193e153dff43c2390a55ee84757f63f04d87008ea4b0889b3b06242f34" => :mountain_lion
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
          <string>#{bin}/spoof-mac</string>
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
