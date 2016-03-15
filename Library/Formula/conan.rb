class Conan < Formula
  desc "Distributed, open source, package manager for C/C++"
  homepage "https://github.com/conan-io/conan"
  url "https://pypi.python.org/packages/source/c/conan/conan-0.7.4.tar.gz"
  sha256 "8cb746e071b0f9f29416fa5ae26c426aaa2ad4bcc7b6b400fb3f9189a37928dd"

  bottle do
    cellar :any_skip_relocation
    sha256 "7fd1ab1b40db0a75681c81ea9117fe336d6fde10f4ad99146642cf49bf9380af" => :el_capitan
    sha256 "78da76f55ceb3fd0ce931c768bfd754fbe4dfe31725f6e0ad13adaf980d7406e" => :yosemite
    sha256 "e5bc12843c58da66d2825c379452882edbb3bb7ba883a2e989c55e75047669be" => :mavericks
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

  def install
    ENV.prepend_create_path "PYTHONPATH", libexec/"vendor/lib/python2.7/site-packages"
    %w[boto bottle cfgparse colorama passlib patch PyJWT PyYAML requests].each do |r|
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
