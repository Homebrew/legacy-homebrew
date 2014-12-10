require "formula"

class Onepass < Formula
  homepage "https://github.com/georgebrock/1pass"
  url "https://github.com/georgebrock/1pass/archive/0.2.1.tar.gz"
  sha1 "47adac676208d83e9c9eca089894165868147547"
  head "https://github.com/georgebrock/1pass.git"

  bottle do
    cellar :any
    sha1 "0e176102fe921829153966c94fbc04330edd0c99" => :mavericks
    sha1 "77a3b651bba41e935f90be247f49fb5e86d6e74c" => :mountain_lion
    sha1 "6157ab9f7546726710df517044e5cabce7c6ad8b" => :lion
  end

  depends_on :python if MacOS.version <= :snow_leopard
  depends_on "swig" => :build

  resource "M2Crypto" do
    url "https://pypi.python.org/packages/source/M/M2Crypto/M2Crypto-0.22.3.tar.gz"
    sha1 "c5e39d928aff7a47e6d82624210a7a31b8220a50"
  end

  resource "fuzzywuzzy" do
    url "https://pypi.python.org/packages/source/f/fuzzywuzzy/fuzzywuzzy-0.2.tar.gz"
    sha1 "ef080ced775dee1669150ebe4bd93c69f51af16f"
  end

  def install
    ENV.prepend_create_path "PYTHONPATH", "#{libexec}/lib/python2.7/site-packages"

    install_args = [ "setup.py", "install", "--prefix=#{libexec}" ]
    resource("M2Crypto").stage { system "python", *install_args }
    resource("fuzzywuzzy").stage { system "python", *install_args }

    system "python", "setup.py", "install", "--prefix=#{libexec}"
    bin.install Dir[libexec/"bin/*"]
    (share+"tests").install Dir["tests/data/*"]
    bin.env_script_all_files(libexec+"bin", :PYTHONPATH => ENV["PYTHONPATH"])
  end

  test do
    assert_equal "123456", `echo "badger" | #{bin}/1pass --no-prompt --path #{share}/tests/1Password.Agilekeychain onetosix`.strip
    assert_equal 0, $?.exitstatus
  end
end
