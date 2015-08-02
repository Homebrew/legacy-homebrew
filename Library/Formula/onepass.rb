class Onepass < Formula
  desc "Command-line interface for 1Password"
  homepage "https://github.com/georgebrock/1pass"
  url "https://github.com/georgebrock/1pass/archive/0.2.1.tar.gz"
  sha256 "44efacfd88411e3405afcabb98c6bb03b15ca6e5a735fd561653379b880eb946"
  head "https://github.com/georgebrock/1pass.git"
  revision 1

  bottle do
    cellar :any
    sha256 "164750979c6f70440988c6ae79fa2ca6ff1733e280ba77ef98814c1f3fd32413" => :yosemite
    sha256 "131288eb9f84f72e215e3c420f5daaa04692e57b2f686a1b91225d4e3737b90b" => :mavericks
    sha256 "3b05aa6c3f5511a46374b46cb93708254ad5edaf87a92b8f9a01c83cc48bfb20" => :mountain_lion
  end

  depends_on :python if MacOS.version <= :snow_leopard
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

  resource "M2Crypto" do
    url "https://pypi.python.org/packages/source/M/M2Crypto/M2Crypto-0.22.3.tar.gz"
    sha256 "6071bfc817d94723e9b458a010d565365104f84aa73f7fe11919871f7562ff72"
  end

  resource "fuzzywuzzy" do
    url "https://pypi.python.org/packages/source/f/fuzzywuzzy/fuzzywuzzy-0.2.tar.gz"
    sha256 "3e241144737adca0628b1da90ec1634b6e792fb320b02ad4147ea2895a155222"
  end

  def install
    resource("swig304").stage do
      system "./configure", "--disable-dependency-tracking", "--prefix=#{buildpath}/swig"
      system "make"
      system "make", "install"
    end

    ENV.prepend_path "PATH", buildpath/"swig/bin"

    ENV.prepend_create_path "PYTHONPATH", libexec/"vendor/lib/python2.7/site-packages"
    resource("fuzzywuzzy").stage do
      system "python", *Language::Python.setup_install_args(libexec/"vendor")
    end

    # M2Crypto always has to be done individually as we have to inreplace OpenSSL path
    resource("M2Crypto").stage do
      inreplace "setup.py", "self.openssl = '/usr'", "self.openssl = '#{Formula["openssl"].opt_prefix}'"
      system "python", *Language::Python.setup_install_args(libexec/"vendor")
    end

    ENV.prepend_create_path "PYTHONPATH", libexec/"lib/python2.7/site-packages"
    system "python", *Language::Python.setup_install_args(libexec)

    bin.install Dir["#{libexec}/bin/*"]
    bin.env_script_all_files(libexec/"bin", :PYTHONPATH => ENV["PYTHONPATH"])
    (share+"tests").install Dir["tests/data/*"]
  end

  test do
    assert_equal "123456", `echo "badger" | #{bin}/1pass --no-prompt --path #{share}/tests/1Password.Agilekeychain onetosix`.strip
    assert_equal 0, $?.exitstatus
  end
end
