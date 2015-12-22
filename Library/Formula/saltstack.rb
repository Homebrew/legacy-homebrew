class Saltstack < Formula
  desc "Dynamic infrastructure communication bus"
  homepage "http://www.saltstack.org"
  # please use sdists published as release downloads
  # (URLs starting with https://github.com/saltstack/salt/releases/download)
  # github tag archives will report wrong version number
  # https://github.com/Homebrew/homebrew/issues/43493
  url "https://github.com/saltstack/salt/releases/download/v2015.8.3/salt-2015.8.3.tar.gz"
  sha256 "4cda3a49d9dc57e849ec93014d31a1983a191c0a88c8ee4d7162e975b67a6b56"
  head "https://github.com/saltstack/salt.git", :branch => "develop", :shallow => false

  bottle do
    cellar :any
    sha256 "582d09b4f2b5c4231dd3a552a47fd80612a6a9c924edb774fd6a8060915caece" => :el_capitan
    sha256 "889cec460d10d59fdd7ba797e39265a675fa4e4f92bbc545fa0f0856a584d2b1" => :yosemite
    sha256 "5f9e12ce508da8cf3c8ba48250356ef6e0167b5255980f6da04da4c59800824f" => :mavericks
  end

  depends_on :python if MacOS.version <= :snow_leopard
  depends_on "zeromq"
  depends_on "libyaml"
  depends_on "swig" => :build
  depends_on "openssl" # For M2Crypto

  resource "six" do
    url "https://pypi.python.org/packages/source/s/six/six-1.10.0.tar.gz"
    sha256 "105f8d68616f8248e24bf0e9372ef04d3cc10104f1980f54d57b2ce73a5ad56a"
  end

  resource "m2crypto" do
    url "https://pypi.python.org/packages/source/M/M2Crypto/M2Crypto-0.22.6rc4.tar.gz"
    sha256 "466c6058bcdf504e6e83c731bbb69490cf73a314459fb4c183e5aee29d066f81"
  end

  resource "requests" do
    url "https://pypi.python.org/packages/source/r/requests/requests-2.9.0.tar.gz"
    sha256 "4881966532b5a36c552244fd909de66d1b8c4a26086f56fd5837cfcde63f8eb8"
  end

  resource "futures" do
    url "https://pypi.python.org/packages/source/f/futures/futures-3.0.3.tar.gz"
    sha256 "2fe2342bb4fe8b8e217f0d21b5921cbe5408bf966d9f92025e707e881b198bed"
  end

  resource "pycrypto" do
    url "https://pypi.python.org/packages/source/p/pycrypto/pycrypto-2.6.1.tar.gz"
    sha256 "f2ce1e989b272cfcb677616763e0a2e7ec659effa67a88aa92b3a65528f60a3c"
  end

  resource "pyyaml" do
    url "https://pypi.python.org/packages/source/P/PyYAML/PyYAML-3.11.tar.gz"
    sha256 "c36c938a872e5ff494938b33b14aaa156cb439ec67548fcab3535bb78b0846e8"
  end

  resource "markupsafe" do
    url "https://pypi.python.org/packages/source/M/MarkupSafe/MarkupSafe-0.23.tar.gz"
    sha256 "a4ec1aff59b95a14b45eb2e23761a0179e98319da5a7eb76b56ea8cdc7b871c3"
  end

  resource "jinja2" do
    url "https://pypi.python.org/packages/source/J/Jinja2/Jinja2-2.8.tar.gz"
    sha256 "bc1ff2ff88dbfacefde4ddde471d1417d3b304e8df103a7a9437d47269201bf4"
  end

  resource "pyzmq" do
    url "https://pypi.python.org/packages/source/p/pyzmq/pyzmq-15.1.0.tar.gz"
    sha256 "bd5b279998538bb197baf59c81584550d713b1b17761e8a638bb6fbda9e5d08d"
  end

  resource "msgpack-python" do
    url "https://pypi.python.org/packages/source/m/msgpack-python/msgpack-python-0.4.6.tar.gz"
    sha256 "bfcc581c9dbbf07cc2f951baf30c3249a57e20dcbd60f7e6ffc43ab3cc614794"
  end

  # Required by tornado
  resource "certifi" do
    url "https://pypi.python.org/packages/source/c/certifi/certifi-2015.11.20.1.tar.gz"
    sha256 "30b0a7354a1b32caa8b4705d3f5fb2dadefac7ba4bf8af8a2176869f93e38f16"
  end

  # Required by tornado
  resource "backports.ssl_match_hostname" do
    url "https://pypi.python.org/packages/source/b/backports.ssl_match_hostname/backports.ssl_match_hostname-3.4.0.2.tar.gz"
    sha256 "07410e7fb09aab7bdaf5e618de66c3dac84e2e3d628352814dc4c37de321d6ae"
  end

  # Required by tornado
  resource "backports_abc" do
    url "https://pypi.python.org/packages/source/b/backports_abc/backports_abc-0.4.tar.gz"
    sha256 "8b3e4092ba3d541c7a2f9b7d0d9c0275b21c6a01c53a61c731eba6686939d0a5"
  end

  # Required by tornado
  resource "singledispatch" do
    url "https://pypi.python.org/packages/source/s/singledispatch/singledispatch-3.4.0.3.tar.gz"
    sha256 "5b06af87df13818d14f08a028e42f566640aef80805c3b50c5056b086e3c2b9c"
  end

  resource "tornado" do
    url "https://pypi.python.org/packages/source/t/tornado/tornado-4.3.tar.gz"
    sha256 "c9c2d32593d16eedf2cec1b6a41893626a2649b40b21ca9c4cac4243bde2efbf"
  end

  def install
    ENV.prepend_create_path "PYTHONPATH", libexec/"vendor/lib/python2.7/site-packages"

    resources.each do |r|
      r.stage do
        # M2Crypto always has to be done individually as we have to inreplace OpenSSL path
        inreplace "setup.py", "self.openssl = '/usr'", "self.openssl = '#{Formula["openssl"].opt_prefix}'" if r.name == "m2crypto"
        system "python", *Language::Python.setup_install_args(libexec/"vendor")
      end
    end

    ENV.prepend_create_path "PYTHONPATH", libexec/"lib/python2.7/site-packages"
    system "python", *Language::Python.setup_install_args(libexec)
    man1.install Dir["doc/man/*.1"]
    man7.install Dir["doc/man/*.7"]

    # Install sample configuration files
    (etc/"saltstack").install Dir["conf/*"]

    bin.install Dir["#{libexec}/bin/*"]
    bin.env_script_all_files(libexec+"bin", :PYTHONPATH => ENV["PYTHONPATH"])
  end

  def caveats; <<-EOS.undent
    Sample configuration files have been placed in #{etc}/saltstack.
    Saltstack will not use these by default.
    EOS
  end

  test do
    ENV.prepend_path "PYTHONPATH", libexec/"vendor/lib/python2.7/site-packages"
    system "python", "-c", "import M2Crypto"

    system "#{bin}/salt", "--version"
  end
end
