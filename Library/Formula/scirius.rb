class Scirius < Formula
  desc "Rules manager for Suricata IDPS"
  homepage "https://github.com/StamusNetworks/scirius"
  url "https://github.com/StamusNetworks/scirius/archive/scirius-1.0.tar.gz"
  sha256 "fde16b3ac8f95e2990a44a9d85aa7c3ee6b55e59af9c27ded7319db19c19b2f5"

  #depends_on :python if MacOS.version <= :snow_leopard
  depends_on "python"

  resource "daemon" do
    url "https://pypi.python.org/packages/source/d/daemon/daemon-1.1.tar.gz"
    sha1 "520de0f52875417da165ff05167c33e6cdfb218c"
  end

  resource "Django" do
    url "https://pypi.python.org/packages/source/D/Django/Django-1.8.tar.gz"
    sha1 "19f5468e100b5004b020b59d4f457483122b3e45"
  end

  resource "django-bootstrap3" do
    url "https://pypi.python.org/packages/source/d/django-bootstrap3/django-bootstrap3-5.4.0.tar.gz"
    sha1 "9c56ca0fabfa2b18a3f7a91b14bf1866343b2c80"
  end

  resource "django-revproxy" do
    url "https://pypi.python.org/packages/source/d/django-revproxy/django-revproxy-0.9.0.tar.gz"
    sha1 "378a51b9c1bb0b5955c8e11842f03848eecac0f8"
  end

    resource "django-tables2" do
    url "https://pypi.python.org/packages/source/d/django-tables2/django-tables2-0.16.0.tar.gz"
    sha1 "ef3c2e9d7fb2961cee41399607589fcb9eb06b63"
  end

    resource "gitdb" do
    url "https://pypi.python.org/packages/source/g/gitdb/gitdb-0.6.4.tar.gz"
    sha1 "21cbba28199802e73e0c4a83b7c02369bbf8c7d7"
  end

    resource "GitPython" do
    url "https://pypi.python.org/packages/source/G/GitPython/GitPython-1.0.0.tar.gz"
    sha1 "0c102b969973dd055488e519e1854094533c5cfe"
  end

    resource "psutil" do
    url "https://pypi.python.org/packages/source/p/psutil/psutil-2.2.1.tar.gz"
    sha1 "ddf58b3a0e699e142586b67097e3ae062766f11d"
  end

      resource "Pygments" do
    url "https://pypi.python.org/packages/source/P/Pygments/Pygments-2.0.2.tar.gz"
    sha1 "fe2c8178a039b6820a7a86b2132a2626df99c7f8"
  end

    resource "pytz" do
    url "https://pypi.python.org/packages/source/p/pytz/pytz-2015.2.tar.bz2"
    sha1 "9a1b8bf9b1222f63f7d677f124453d13d7ed27c8"
  end

    resource "requests" do
    url "https://pypi.python.org/packages/source/r/requests/requests-2.6.0.tar.gz"
    sha1 "ad7327c73e8be8c188ad489d511097202b1fef12"
  end

  resource "six" do
    url "https://pypi.python.org/packages/source/s/six/six-1.9.0.tar.gz"
    sha1 "d168e6d01f0900875c6ecebc97da72d0fda31129"
  end

  resource "smmap" do
    url "https://pypi.python.org/packages/source/s/smmap/smmap-0.9.0.tar.gz"
    sha1 "2aad63033aab4e4cf1a3f75f521d985da8b1353f"
  end

    resource "South" do
    url "https://pypi.python.org/packages/source/S/South/South-1.0.2.tar.gz"
    sha1 "8f9bf809aa8c63e5b46359d3751b76786b9f58c6"
  end

    resource "urllib3" do
    url "https://pypi.python.org/packages/source/u/urllib3/urllib3-1.10.1.tar.gz"
    sha1 "434ff4f51b566076ed2f41ff71f24e1b0d5c9ebd"
  end

  def install
    ENV.prepend_create_path "PYTHONPATH", libexec/"vendor/lib/python2.7/site-packages"
    %w[daemon Django django-bootstrap3 django-revproxy django-tables2 gitdb GitPython psutil Pygments pytz requests six smmap South urllib3].each do |r|
      resource(r).stage do
        system "python", *Language::Python.setup_install_args(libexec/"vendor")
      end
    end
#
    ENV.prepend_create_path "PYTHONPATH", libexec/"lib/python2.7/site-packages"
    system "python", *Language::Python.setup_install_args(libexec)
#
    bin.install Dir["#{libexec}/bin/*"]
    bin.env_script_all_files(libexec/"bin", :PYTHONPATH => ENV["PYTHONPATH"])
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
                <string>/usr/bin/env python</string>
                <string>#{prefix}/manage.py</string>
                <string>runserver</string>
            </array>
            <key>RunAtLoad</key>
            <true/>
        </dict>
    </plist>
  EOS
  end

  test do
    system "echo", "Done!"
  end
end
