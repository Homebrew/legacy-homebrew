class Saltstack < Formula
  homepage "http://www.saltstack.org"
  url "https://github.com/saltstack/salt/archive/v2014.7.1.tar.gz"
  sha256 "5fcf2cff700d0719b419c9cb489552645ce1287a15c7b3a8745959773d9b0dd1"
  head "https://github.com/saltstack/salt.git", :branch => "develop", :shallow => false
  revision 1

  bottle do
    sha256 "ba2dad536526cb11eea8b250a1197e68c1eec80b512ea90bcd7ea973e3111624" => :yosemite
    sha256 "0bb6b9bb0ea00c8e430213d11be6ef9ef404daef176f401c2d0c89431608f69c" => :mavericks
    sha256 "287ecda2663c99934af942ae0d034bcbb96972afdae6087e47c7abbca198f77d" => :mountain_lion
  end

  devel do
    url "https://github.com/saltstack/salt/archive/v2015.2.0rc2.tar.gz"
    sha256 "be71c1f2f9f878d5f958396620983c5981f55eaf32913e7f28c129c35f37657a"
    version "2015.2.0rc2"
  end

  depends_on :python if MacOS.version <= :snow_leopard
  depends_on "zeromq"
  depends_on "libyaml"
  depends_on "openssl" # For M2Crypto

  # For vendored Swig
  depends_on "pcre" => :build

  # Homebrew's swig breaks M2Crypto due to upstream's undermaintained status.
  # https://github.com/swig/swig/issues/344
  # https://github.com/martinpaljak/M2Crypto/issues/60
  resource "swig304" do
    url "https://downloads.sourceforge.net/project/swig/swig/swig-3.0.4/swig-3.0.4.tar.gz"
    sha256 "410ffa80ef5535244b500933d70c1b65206333b546ca5a6c89373afb65413795"
  end

  # Don't depend on Homebrew's openssl due to upstream build issues with non-system OpenSSL in M2Crypto
  # See: https://github.com/martinpaljak/M2Crypto/issues/11
  resource "m2crypto" do
    url "https://pypi.python.org/packages/source/M/M2Crypto/M2Crypto-0.22.3.tar.gz"
    sha256 "6071bfc817d94723e9b458a010d565365104f84aa73f7fe11919871f7562ff72"
  end

  resource "requests" do
    url "https://pypi.python.org/packages/source/r/requests/requests-2.6.0.tar.gz"
    sha256 "1cdbed1f0e236f35ef54e919982c7a338e4fea3786310933d3a7887a04b74d75"
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
    url "https://pypi.python.org/packages/source/J/Jinja2/Jinja2-2.7.3.tar.gz"
    sha256 "2e24ac5d004db5714976a04ac0e80c6df6e47e98c354cb2c0d82f8879d4f8fdb"
  end

  resource "pyzmq" do
    url "https://pypi.python.org/packages/source/p/pyzmq/pyzmq-14.3.1.tar.gz"
    sha256 "00e263c26a524f81127247e6f37cbf427eddf3a3657d170cf4865bd522df3914"
  end

  resource "msgpack-python" do
    url "https://pypi.python.org/packages/source/m/msgpack-python/msgpack-python-0.4.2.tar.gz"
    sha256 "0476e8fdd79e5b648b349bd0edebf06e41271ee29421ef7adb12cdbe55dac2a9"
  end

  resource "apache-libcloud" do
    url "https://pypi.python.org/packages/source/a/apache-libcloud/apache-libcloud-0.15.1.tar.gz"
    sha256 "f12f80c2f66e46c406c53b90c41eb572c29751c407bdbe7204ec6d9264ce16bc"
  end

  def install
    resource("swig304").stage do
      system "./configure", "--disable-dependency-tracking", "--prefix=#{buildpath}/swig"
      system "make"
      system "make", "install"
    end

    ENV.prepend_path "PATH", buildpath/"swig/bin"

    ENV.prepend_create_path "PYTHONPATH", libexec/"vendor/lib/python2.7/site-packages"
    %w[requests pycrypto pyyaml markupsafe jinja2 pyzmq msgpack-python apache-libcloud].each do |r|
      resource(r).stage do
        system "python", *Language::Python.setup_install_args(libexec/"vendor")
      end
    end

    # M2Crypto always has to be done individually as we have to inreplace OpenSSL path
    resource("m2crypto").stage do
      inreplace "setup.py", "self.openssl = '/usr'", "self.openssl = '#{Formula["openssl"].opt_prefix}'"
      system "python", *Language::Python.setup_install_args(libexec/"vendor")
    end

    ENV.prepend_create_path "PYTHONPATH", libexec/"lib/python2.7/site-packages"
    system "python", *Language::Python.setup_install_args(libexec)
    man1.install Dir["doc/man/*.1"]
    man7.install Dir["doc/man/*.7"]

    bin.install Dir["#{libexec}/bin/*"]
    bin.env_script_all_files(libexec+"bin", :PYTHONPATH => ENV["PYTHONPATH"])
  end

  test do
    system "#{bin}/salt", "--version"
  end
end
