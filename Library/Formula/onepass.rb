class Onepass < Formula
  desc "Command-line interface for 1Password"
  homepage "https://github.com/georgebrock/1pass"
  url "https://github.com/georgebrock/1pass/archive/0.2.1.tar.gz"
  sha256 "44efacfd88411e3405afcabb98c6bb03b15ca6e5a735fd561653379b880eb946"
  head "https://github.com/georgebrock/1pass.git"
  revision 1

  bottle do
    cellar :any
    revision 2
    sha256 "8410258ade7f471629235368ba63f11d124335a8af394a6b16493622b3aac825" => :el_capitan
    sha256 "2172e0aee7c33b6b2f5b2ff8fd7e92064d5bfc3fe03dfcbce6aac9881f08e263" => :yosemite
    sha256 "beb5a20a0642cff5f9e43b6ce1ce9a9c45589ba748150f333e81a0c70090b7f2" => :mavericks
  end

  depends_on :python if MacOS.version <= :snow_leopard
  depends_on "swig" => :build
  depends_on "openssl" # For M2Crypto

  resource "m2crypto" do
    url "https://pypi.python.org/packages/source/M/M2Crypto/M2Crypto-0.23.0.tar.gz"
    sha256 "1ac3b6eafa5ff7e2a0796675316d7569b28aada45a7ab74042ad089d15a9567f"
  end

  resource "fuzzywuzzy" do
    url "https://pypi.python.org/packages/source/f/fuzzywuzzy/fuzzywuzzy-0.8.0.tar.gz"
    sha256 "3845ecd7c790beae111a2d3956b4ba80fe1113eecf045c4b364394eaa01ad9ce"
  end

  resource "python-levenshtein" do
    url "https://pypi.python.org/packages/source/p/python-Levenshtein/python-Levenshtein-0.12.0.tar.gz"
    sha256 "033a11de5e3d19ea25c9302d11224e1a1898fe5abd23c61c7c360c25195e3eb1"
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

    bin.install Dir["#{libexec}/bin/*"]
    bin.env_script_all_files(libexec/"bin", :PYTHONPATH => ENV["PYTHONPATH"])
    (share+"tests").install Dir["tests/data/*"]
  end

  test do
    assert_equal "123456", `echo "badger" | #{bin}/1pass --no-prompt --path #{share}/tests/1Password.Agilekeychain onetosix`.strip
    assert_equal 0, $?.exitstatus
  end
end
