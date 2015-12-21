class Logentries < Formula
  desc "Utility for access to logentries logging infrastructure"
  homepage "https://logentries.com/doc/agent/"
  url "https://github.com/logentries/le/archive/v1.4.27.tar.gz"
  sha256 "218ca34395445312aeb77eb23a9bf589771da5fac9feca9b82646f57867abc2f"
  head "https://github.com/logentries/le.git"

  bottle do
    cellar :any
    sha256 "8615d925ca86af2271dd691aecacd56b9fcf06e02da8fd85d2df6ca1c046bb81" => :yosemite
    sha256 "26306f8ae96b9e5250e75a463db1c33666f87bb002dc3aea8bb9c3f05fc54b10" => :mavericks
    sha256 "c820319df665f263cf8b7a9190a4e79fdaaf46509d429a71362d81a2626b027b" => :mountain_lion
  end

  conflicts_with "le", :because => "both install a le binary"

  def install
    ENV.prepend_create_path "PYTHONPATH", libexec/"lib/python2.7/site-packages"
    system "python", *Language::Python.setup_install_args(libexec)

    bin.install Dir["#{libexec}/bin/*"]
    bin.env_script_all_files(libexec/"bin", :PYTHONPATH => ENV["PYTHONPATH"])
  end

  plist_options :manual => "le monitor"

  def plist; <<-EOS.undent
    <?xml version="1.0" encoding="UTF-8"?>
    <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
    <plist version="1.0">
      <dict>
        <key>Label</key>
        <string>#{plist_name}</string>
        <key>ProgramArguments</key>
        <array>
        <string>#{opt_bin}/le</string>
        <string>monitor</string>
        </array>
        <key>KeepAlive</key>
        <true/>
        <key>RunAtLoad</key>
        <true/>
      </dict>
    </plist>
    EOS
  end

  test do
    shell_output("#{bin}/le --help", 4)
  end
end
