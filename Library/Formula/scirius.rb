class Scirius < Formula
  desc "Rules manager for Suricata IDPS"
  homepage "https://github.com/StamusNetworks/scirius"
  url "https://github.com/StamusNetworks/scirius/archive/scirius-1.0.tar.gz"
  sha256 "fde16b3ac8f95e2990a44a9d85aa7c3ee6b55e59af9c27ded7319db19c19b2f5"

  depends_on :python if MacOS.version <= :snow_leopard

  resource "daemon" do
    url "https://pypi.python.org/packages/source/d/daemon/daemon-1.1.tar.gz"
    sha256 "acab001b35f4b1a24210ba0900740b7b6eda1f5eb3e8128f8768c98622d5162f"
  end
  resource "Django" do
    url "https://pypi.python.org/packages/source/D/Django/Django-1.8.3.tar.gz"
    sha256 "2bb654fcc05fd53017c88caf2bc38b5c5ea23c91f8ac7f0a28b290daf2305bba"
  end
  resource "django-bootstrap3" do
    url "https://pypi.python.org/packages/source/d/django-bootstrap3/django-bootstrap3-6.1.0.tar.gz"
    sha256 "519948e5172aa1bffd3422e28c8b5362626d9a0b5a61eeaf78dd78d3feaad4a0"
  end
  resource "django-revproxy" do
    url "https://pypi.python.org/packages/source/d/django-revproxy/django-revproxy-0.9.3.tar.gz"
    sha256 "251775c6e6de1803f93c1fdca16f2c3209306d2e9642fffa8018f416b9e3ffba"
  end
  resource "django-tables2" do
    url "https://pypi.python.org/packages/source/d/django-tables2/django-tables2-1.0.4.tar.gz"
    sha256 "801b1df349f07f5b548cf4b3d5cddfc26e5969079c7d490f179fb649e76d24af"
  end
  resource "gitdb" do
    url "https://pypi.python.org/packages/source/g/gitdb/gitdb-0.6.4.tar.gz"
    sha256 "a3ebbc27be035a2e874ed904df516e35f4a29a778a764385de09de9e0f139658"
  end
  resource "GitPython" do
    url "https://pypi.python.org/packages/source/G/GitPython/GitPython-1.0.1.tar.gz"
    sha256 "9c88c17bbcae2a445ff64024ef13526224f70e35e38c33416be5ceb56ca7f760"
  end
  resource "psutil" do
    url "https://pypi.python.org/packages/source/p/psutil/psutil-2.2.1.tar.gz"
    sha256 "a0e9b96f1946975064724e242ac159f3260db24ffa591c3da0a355361a3a337f"
  end
  resource "Pygments" do
    url "https://pypi.python.org/packages/source/P/Pygments/Pygments-1.6.tar.gz"
    sha256 "799ed4caf77516e54440806d8d9cd82a7607dfdf4e4fb643815171a4b5c921c0"
  end
  resource "pytz" do
    url "https://pypi.python.org/packages/source/p/pytz/pytz-2015.4.tar.bz2"
    sha256 "a78b484d5472dd8c688f8b3eee18646a25c66ce45b2c26652850f6af9ce52b17"
  end
  resource "requests" do
    url "https://pypi.python.org/packages/source/r/requests/requests-2.7.0.tar.gz"
    sha256 "398a3db6d61899d25fd4a06c6ca12051b0ce171d705decd7ed5511517b4bb93d"
  end
  resource "six" do
    url "https://pypi.python.org/packages/source/s/six/six-1.9.0.tar.gz"
    sha256 "e24052411fc4fbd1f672635537c3fc2330d9481b18c0317695b46259512c91d5"
  end
  resource "smmap" do
    url "https://pypi.python.org/packages/source/s/smmap/smmap-0.9.0.tar.gz"
    sha256 "0e2b62b497bd5f0afebc002eda4d90df9d209c30ef257e8673c90a6b5c119d62"
  end
  resource "South" do
    url "https://pypi.python.org/packages/source/S/South/South-1.0.2.tar.gz"
    sha256 "d360bd31898f9df59f6faa786551065bba45b35e7ee3c39b381b4fbfef7392f4"
  end
  resource "urllib3" do
    url "https://pypi.python.org/packages/source/u/urllib3/urllib3-1.10.4.tar.gz"
    sha256 "52131e6a561466f1206e1a648d9a73dda2a804d0f70e83782bd88494542ded09"
  end

  def install
    (libexec/"vendor/lib/python2.7/site-packages").mkpath
    resources.each do |r|
      r.stage do
        system "python", *Language::Python.setup_install_args(libexec/"vendor")
      end
    end

    (libexec/"lib/python2.7/site-packages").install "scirius", "suricata", "rules", "accounts"
    libexec.install "manage.py"
    doc.install Dir["doc/*"], "README.rst"
    prefix.install Dir["*"]

    chmod 0755, libexec/"manage.py"
    (bin/"scirius").write <<-EOS.undent
      #!/bin/bash
      export PYTHONPATH="#{libexec}/vendor/lib/python2.7/site-packages:#{libexec}/lib/python2.7/site-packages"
      /usr/bin/env python "#{libexec}/manage.py" "$@"
    EOS
  end

  plist_options :manual => "python"

  def plist; <<-EOS.undent
    <?xml version="1.0" encoding="UTF-8"?>
    <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
    <plist version="1.0">
        <dict>
            <key>KeepAlive</key>
            <true/>
            <key>Label</key>
            <string>#{plist_name}</string>
            <key>ProgramArguments</key>
            <array>
                <string>#{bin}/scirius</string>
                <string>runserver</string>
            </array>
            <key>RunAtLoad</key>
            <true/>
        </dict>
    </plist>
  EOS
  end

  test do
    system "true"
  end
end
