class Sickrage < Formula
  desc "Automatic video library manager for TV Shows"
  homepage "https://www.sickrage.tv"
  url "https://github.com/SiCKRAGETV/SickRage/archive/v4.0.76.2.tar.gz"
  sha256 "bb47558fa67ec8d5d728f6ce9cdb4dc4a80ab505fe17454c8eb43c13c8ce2e3c"
  head "https://github.com/SiCKRAGETV/SickRage.git"

  bottle do
    cellar :any
    sha256 "94f6add1a3f4517b36f2f3861847922851cbb7657c89275d6aea53ab95fa0b70" => :el_capitan
    sha256 "0cb4b2f6e2d290a125737ba670267da20f3851a21677a39895038f18e14df051" => :yosemite
    sha256 "f3463916bf2cac143dbff400394f347f960d552cfbba36d5731677539245b71d" => :mavericks
  end

  depends_on :python if MacOS.version <= :snow_leopard
  depends_on "openssl"

  resource "Cheetah" do
    url "https://pypi.python.org/packages/source/C/Cheetah/Cheetah-2.4.4.tar.gz"
    sha256 "be308229f0c1e5e5af4f27d7ee06d90bb19e6af3059794e5fd536a6f29a9b550"
  end

  resource "Markdown" do
    url "https://pypi.python.org/packages/source/M/Markdown/Markdown-2.6.3.tar.gz"
    sha256 "ad75fc03c45492eba3bc63645e1e6465f65523a05fff0abf36910f810465a9af"
  end

  resource "pyOpenSSL" do
    url "https://pypi.python.org/packages/source/p/pyOpenSSL/pyOpenSSL-0.15.1.tar.gz"
    sha256 "f0a26070d6db0881de8bcc7846934b7c3c930d8f9c79d45883ee48984bc0d672"
  end

  resource "cffi" do
    url "https://pypi.python.org/packages/source/c/cffi/cffi-1.3.0.tar.gz"
    sha256 "9daa53aff0b5cf64c85c10eab7ce6776880d0ee71b78cedeae196ae82b6734e9"
  end

  resource "cryptography" do
    url "https://pypi.python.org/packages/source/c/cryptography/cryptography-1.1.tar.gz"
    sha256 "059bc6428b1d0e2317f505698602642f1d8dda5b120ec573a59a430d8cb7a32d"
  end

  resource "enum34" do
    url "https://pypi.python.org/packages/source/e/enum34/enum34-1.0.4.tar.gz"
    sha256 "d3c19f26a6a34629c18c775f59dfc5dd595764c722b57a2da56ebfb69b94e447"
  end

  resource "idna" do
    url "https://pypi.python.org/packages/source/i/idna/idna-2.0.tar.gz"
    sha256 "16199aad938b290f5be1057c0e1efc6546229391c23cea61ca940c115f7d3d3b"
  end

  resource "ipaddress" do
    url "https://pypi.python.org/packages/source/i/ipaddress/ipaddress-1.0.14.tar.gz"
    sha256 "226f4be44c6cb64055e23060848266f51f329813baae28b53dc50e93488b3b3e"
  end

  resource "pyasn1" do
    url "https://pypi.python.org/packages/source/p/pyasn1/pyasn1-0.1.9.tar.gz"
    sha256 "853cacd96d1f701ddd67aa03ecc05f51890135b7262e922710112f12a2ed2a7f"
  end

  resource "pycparser" do
    url "https://pypi.python.org/packages/source/p/pycparser/pycparser-2.14.tar.gz"
    sha256 "7959b4a74abdc27b312fed1c21e6caf9309ce0b29ea86b591fd2e99ecdf27f73"
  end

  resource "six" do
    url "https://pypi.python.org/packages/source/s/six/six-1.10.0.tar.gz"
    sha256 "105f8d68616f8248e24bf0e9372ef04d3cc10104f1980f54d57b2ce73a5ad56a"
  end

  def install
    ENV.prepend_create_path "PYTHONPATH", libexec/"vendor/lib/python2.7/site-packages"
    resources.each do |r|
      r.stage do
        system "python", *Language::Python.setup_install_args(libexec/"vendor")
      end
    end

    libexec.install Dir["*"]

    (bin/"sickrage").write <<-EOS.undent
      #!/bin/bash
      export PYTHONPATH="#{libexec}/vendor/lib/python2.7/site-packages:$PYTHONPATH"
      python "#{libexec}/SickBeard.py"\
        "--pidfile=#{var}/run/sickrage.pid"\
        "--datadir=#{etc}/sickrage"\
        "$@"
    EOS
  end

  plist_options :manual => "sickrage"

  def plist; <<-EOS.undent
    <?xml version="1.0" encoding="UTF-8"?>
    <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
    <plist version="1.0">
    <dict>
      <key>Label</key>
      <string>#{plist_name}</string>
      <key>ProgramArguments</key>
      <array>
        <string>#{opt_bin}/sickrage</string>
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

  test do
    assert_match /SickBeard\.py/, shell_output("#{bin}/sickrage --help 2>&1", 1)
  end
end
