class Stormssh < Formula
  desc "Command-line tool to manage your ssh connections"
  homepage "https://github.com/emre/storm"
  url "https://pypi.python.org/packages/source/s/stormssh/stormssh-0.6.5.tar.gz"
  sha256 "1111eb2c9103847078154a4bc444b105326c6298a110d05fb625cb195eac468a"
  head "https://github.com/emre/storm.git"

  bottle do
    cellar :any
    sha1 "9eea265af64ced78ae0b8019a7ee351ebe8740cf" => :yosemite
    sha1 "e1f25f89dabc1bdc52bced707b1199e7abd50696" => :mavericks
    sha1 "258a35abfd77d8e2f69230db4aca27dd3fc8a586" => :mountain_lion
  end

  conflicts_with "storm", :because => "both install 'storm' binary"

  resource "pycrypto" do
    url "https://pypi.python.org/packages/source/p/pycrypto/pycrypto-2.6.1.tar.gz"
    sha256 "f2ce1e989b272cfcb677616763e0a2e7ec659effa67a88aa92b3a65528f60a3c"
  end

  resource "flask" do
    url "https://pypi.python.org/packages/source/F/Flask/Flask-0.10.1.tar.gz"
    sha256 "4c83829ff83d408b5e1d4995472265411d2c414112298f2eb4b359d9e4563373"
  end

  resource "six" do
    url "https://pypi.python.org/packages/source/s/six/six-1.9.0.tar.gz"
    sha256 "e24052411fc4fbd1f672635537c3fc2330d9481b18c0317695b46259512c91d5"
  end

  resource "termcolor" do
    url "https://pypi.python.org/packages/source/t/termcolor/termcolor-1.1.0.tar.gz"
    sha256 "1d6d69ce66211143803fbc56652b41d73b4a400a2891d7bf7a1cdf4c02de613b"
  end

  resource "markupsafe" do
    url "https://pypi.python.org/packages/source/M/MarkupSafe/MarkupSafe-0.23.tar.gz"
    sha256 "a4ec1aff59b95a14b45eb2e23761a0179e98319da5a7eb76b56ea8cdc7b871c3"
  end

  resource "jinja2" do
    url "https://pypi.python.org/packages/source/J/Jinja2/Jinja2-2.7.3.tar.gz"
    sha256 "2e24ac5d004db5714976a04ac0e80c6df6e47e98c354cb2c0d82f8879d4f8fdb"
  end

  resource "werkzeug" do
    url "https://pypi.python.org/packages/source/W/Werkzeug/Werkzeug-0.9.6.tar.gz"
    sha256 "7f11e7e2e73eb22677cac1b11113eb6106f66cedef13d140e83cf6563c90b79c"
  end

  resource "itsdangerous" do
    url "https://pypi.python.org/packages/source/i/itsdangerous/itsdangerous-0.24.tar.gz"
    sha256 "cbb3fcf8d3e33df861709ecaf89d9e6629cff0a217bc2848f1b41cd30d360519"
  end

  resource "ecdsa" do
    url "https://pypi.python.org/packages/source/e/ecdsa/ecdsa-0.11.tar.gz"
    sha256 "8e3b6c193f91dc94b2f3b0261e3eabbdc604f78ff99fdad324a56fdd0b5e958c"
  end

  resource "paramiko" do
    url "https://pypi.python.org/packages/source/p/paramiko/paramiko-1.15.2.tar.gz"
    sha256 "4f56a671a3eecbb76e6143e6e4ca007d503a39aa79aa9e14ade667fa53fd6e55"
  end

  def install
    ENV.prepend_create_path "PYTHONPATH", libexec/"vendor/lib/python2.7/site-packages"
    resources.each do |r|
      r.stage { system "python", *Language::Python.setup_install_args(libexec/"vendor") }
    end

    ENV.prepend_create_path "PYTHONPATH", libexec/"lib/python2.7/site-packages"
    system "python", *Language::Python.setup_install_args(libexec)

    bin.install Dir[libexec/"bin/*"]
    bin.env_script_all_files(libexec/"bin", :PYTHONPATH => ENV["PYTHONPATH"])
  end

  test do
    sshconfig_path = (testpath/"sshconfig")
    touch sshconfig_path

    system bin/"storm", "add", "--config", "sshconfig", "aliastest", "user@example.com:22"

    expected_output = <<-EOS.undent
      Host aliastest
          hostname example.com
          user user
          port 22
    EOS
    assert_equal expected_output, sshconfig_path.read
  end
end
