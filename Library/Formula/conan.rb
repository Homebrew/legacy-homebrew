class Conan < Formula
  desc "Distributed, open source, package manager for C/C++"
  homepage "https://github.com/conan-io/conan"
  url "https://pypi.python.org/packages/source/c/conan/conan-0.8.0.tar.gz"
  sha256 "9062ce6a8ea17b9915897b4bbed294bc28506d4183ddd2f79b61395e7d24c953"

  bottle do
    cellar :any_skip_relocation
    sha256 "59f4bd04d1cc9c140396d2f3e94a997fb2f661b1c507c97590dd2622475f3d12" => :el_capitan
    sha256 "2ed2c773275b640901efcadec762731461edbdf583f9e9af0b520e171f503503" => :yosemite
    sha256 "d481885bbaab2bc8f225aaffe5c67ef89234069a63193b9248b49c89833f136f" => :mavericks
  end

  depends_on :python if MacOS.version <= :snow_leopard

  resource "boto" do
    url "https://pypi.python.org/packages/source/b/boto/boto-2.38.0.tar.gz"
    sha256 "d9083f91e21df850c813b38358dc83df16d7f253180a1344ecfedce24213ecf2"
  end

  resource "bottle" do
    url "https://pypi.python.org/packages/source/b/bottle/bottle-0.12.9.tar.gz"
    sha256 "fe0a24b59385596d02df7ae7845fe7d7135eea73799d03348aeb9f3771500051"
  end

  resource "cfgparse" do
    url "https://pypi.python.org/packages/source/c/cfgparse/cfgparse-1.3.zip"
    sha256 "adc830323e4d9872af1a81364dd18e958b5550c3cc2d1f05929ec2634147f2f9"
  end

  resource "colorama" do
    url "https://pypi.python.org/packages/source/c/colorama/colorama-0.3.5.tar.gz"
    sha256 "0880a751afcb111881b437a846a93e540c7e1346030ba7bd7fda03434371fbc3"
  end

  resource "fasteners" do
    url "https://pypi.python.org/packages/source/f/fasteners/fasteners-0.14.1.tar.gz"
    sha256 "427c76773fe036ddfa41e57d89086ea03111bbac57c55fc55f3006d027107e18"
  end

  resource "monotonic" do
    url "https://pypi.python.org/packages/source/m/monotonic/monotonic-1.0.tar.gz"
    sha256 "47d7d045b3f2a08bffe683d761ef7f9131a2598db1cec7532a06720656cf719d"
  end

  resource "passlib" do
    url "https://pypi.python.org/packages/source/p/passlib/passlib-1.6.5.tar.gz"
    sha256 "a83d34f53dc9b17aa42c9a35c3fbcc5120f3fcb07f7f8721ec45e6a27be347fc"
  end

  resource "patch" do
    url "https://pypi.python.org/packages/source/p/patch/patch-1.15.zip"
    sha256 "c9ebda243e569dddf0eb87fd8e9cb1cbc02d63ff63abd4aa2204ace5d5fb833d"
  end

  resource "PyJWT" do
    url "https://pypi.python.org/packages/source/P/PyJWT/PyJWT-1.4.0.tar.gz"
    sha256 "e1b2386cfad541445b1d43e480b02ca37ec57259fd1a23e79415b57ba5d8a694"
  end

  resource "PyYAML" do
    url "https://pypi.python.org/packages/source/P/PyYAML/PyYAML-3.11.tar.gz"
    sha256 "c36c938a872e5ff494938b33b14aaa156cb439ec67548fcab3535bb78b0846e8"
  end

  resource "requests" do
    url "https://pypi.python.org/packages/source/r/requests/requests-2.7.0.tar.gz"
    sha256 "398a3db6d61899d25fd4a06c6ca12051b0ce171d705decd7ed5511517b4bb93d"
  end

  resource "six" do
    url "https://pypi.python.org/packages/source/s/six/six-1.5.2.tar.gz"
    sha256 "fc6beeffdd8fc76b783287eb77d093425d0710920aae2c70acd693c52d7e8cf8"
  end

  def install
    ENV.prepend_create_path "PYTHONPATH", libexec/"vendor/lib/python2.7/site-packages"
    %w[boto bottle cfgparse colorama fasteners monotonic passlib patch PyJWT PyYAML requests six].each do |r|
      resource(r).stage do
        system "python", *Language::Python.setup_install_args(libexec/"vendor")
      end
    end

    ENV.prepend_create_path "PYTHONPATH", libexec/"lib/python2.7/site-packages"
    system "python", *Language::Python.setup_install_args(libexec)

    bin.install Dir[libexec/"bin/*"]
    bin.env_script_all_files(libexec/"bin", :PYTHONPATH => ENV["PYTHONPATH"])
  end

  test do
    system "#{bin}/conan", "install", "zlib/1.2.8@lasote/stable"
  end
end
