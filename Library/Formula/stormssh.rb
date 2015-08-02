class Stormssh < Formula
  desc "Command-line tool to manage your ssh connections"
  homepage "https://github.com/emre/storm"
  url "https://pypi.python.org/packages/source/s/stormssh/stormssh-0.6.5.tar.gz"
  sha1 "3788fca510dc1a46aa21adea98749c354d85b3cc"
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
    sha1 "aeda3ed41caf1766409d4efc689b9ca30ad6aeb2"
  end

  resource "flask" do
    url "https://pypi.python.org/packages/source/F/Flask/Flask-0.10.1.tar.gz"
    sha1 "d3d078262b053f4438e2ed3fd6f9b923c2c92172"
  end

  resource "six" do
    url "https://pypi.python.org/packages/source/s/six/six-1.9.0.tar.gz"
    sha1 "d168e6d01f0900875c6ecebc97da72d0fda31129"
  end

  resource "termcolor" do
    url "https://pypi.python.org/packages/source/t/termcolor/termcolor-1.1.0.tar.gz"
    sha1 "52045880a05c0fbd192343d9c9aad46a73d20e8c"
  end

  resource "markupsafe" do
    url "https://pypi.python.org/packages/source/M/MarkupSafe/MarkupSafe-0.23.tar.gz"
    sha1 "cd5c22acf6dd69046d6cb6a3920d84ea66bdf62a"
  end

  resource "jinja2" do
    url "https://pypi.python.org/packages/source/J/Jinja2/Jinja2-2.7.3.tar.gz"
    sha1 "25ab3881f0c1adfcf79053b58de829c5ae65d3ac"
  end

  resource "werkzeug" do
    url "https://pypi.python.org/packages/source/W/Werkzeug/Werkzeug-0.9.6.tar.gz"
    sha1 "d1bc1153ea45c6951845338a8499d94bad46e316"
  end

  resource "itsdangerous" do
    url "https://pypi.python.org/packages/source/i/itsdangerous/itsdangerous-0.24.tar.gz"
    sha1 "0a6ae9c20cd72e89d75314ebc7b0f390f93e6a0d"
  end

  resource "ecdsa" do
    url "https://pypi.python.org/packages/source/e/ecdsa/ecdsa-0.11.tar.gz"
    sha1 "f732f8cdb064bbe47aa830cc2654688da95b78f0"
  end

  resource "paramiko" do
    url "https://pypi.python.org/packages/source/p/paramiko/paramiko-1.15.2.tar.gz"
    sha1 "754ffa47fd6f78b93fc56437cf14a79bef094f0f"
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
