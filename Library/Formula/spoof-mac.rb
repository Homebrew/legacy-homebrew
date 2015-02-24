class SpoofMac < Formula
  homepage "http://feross.org/spoofmac/"
  url "https://pypi.python.org/packages/source/S/SpoofMAC/SpoofMAC-2.0.0.tar.gz"
  sha1 "6a1d44ee300f30c1e2406fa612950adedc7367d2"
  head "https://github.com/feross/SpoofMAC.git"

  bottle do
    sha1 "13efa686db9f20bc7cfb69f2ebc18583c2bb990e" => :yosemite
    sha1 "2d68dfc7103ce1c3f99d1a6a48460bc7370310a2" => :mavericks
    sha1 "bdecbe4eb2ccd5ddb2f340922c37f652e1b3b1f2" => :mountain_lion
  end

  depends_on :python if MacOS.version <= :snow_leopard

  resource "docopt" do
    url "https://pypi.python.org/packages/source/d/docopt/docopt-0.6.2.tar.gz"
    sha1 "224a3ec08b56445a1bd1583aad06b00692671e04"
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
