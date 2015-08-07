# No head build supported; if you need head builds of Mercurial, do so outside
# of Homebrew.
class Mercurial < Formula
  desc "Scalable distributed version control system"
  homepage "https://mercurial.selenic.com/"
  url "https://mercurial.selenic.com/release/mercurial-3.5.tar.gz"
  sha256 "b50f6978e7d39fe0cb298fa3fa3e9ce41d2356721d155e5288f9c57e5f13e9a7"

  bottle do
    cellar :any
    revision 1
    sha256 "e898db2838af928886d849f5d3db058189824eabb469d5b950bacf62f47c624b" => :yosemite
    sha256 "70febfeb93a25fddf1a53f081ce129347f3896893ec6ff4f0acb93d7bfcc6aed" => :mavericks
    sha256 "43e273e2a20d66d05e25505578949b042257df64bfe731d4a5e7d1b37b3c4c0c" => :mountain_lion
  end

  depends_on "openssl"

  resource "six" do
    url "https://pypi.python.org/packages/source/s/six/six-1.9.0.tar.gz"
    sha256 "e24052411fc4fbd1f672635537c3fc2330d9481b18c0317695b46259512c91d5"
  end

  resource "enum34" do
    url "https://pypi.python.org/packages/source/e/enum34/enum34-1.0.4.tar.gz"
    sha256 "d3c19f26a6a34629c18c775f59dfc5dd595764c722b57a2da56ebfb69b94e447"
  end

  resource "pyasn1" do
    url "https://pypi.python.org/packages/source/p/pyasn1/pyasn1-0.1.8.tar.gz"
    sha256 "5d33be7ca0ec5997d76d29ea4c33b65c00c0231407fff975199d7f40530b8347"
  end

  resource "idna" do
    url "https://pypi.python.org/packages/source/i/idna/idna-2.0.tar.gz"
    sha256 "16199aad938b290f5be1057c0e1efc6546229391c23cea61ca940c115f7d3d3b"
  end

  resource "ipaddress" do
    url "https://pypi.python.org/packages/source/i/ipaddress/ipaddress-1.0.14.tar.gz"
    sha256 "226f4be44c6cb64055e23060848266f51f329813baae28b53dc50e93488b3b3e"
  end

  resource "pycparser" do
    url "https://pypi.python.org/packages/source/p/pycparser/pycparser-2.14.tar.gz"
    sha256 "7959b4a74abdc27b312fed1c21e6caf9309ce0b29ea86b591fd2e99ecdf27f73"
  end

  resource "cffi" do
    url "https://pypi.python.org/packages/source/c/cffi/cffi-1.1.2.tar.gz"
    sha256 "390970b602708c91ddc73953bb6929e56291c18a4d80f360afa00fad8b6f3339"
  end

  resource "cryptography" do
    url "https://pypi.python.org/packages/source/c/cryptography/cryptography-0.9.3.tar.gz"
    sha256 "aed022f738dd9adb840d92960b0464ea1fbb222ba118938858eb93fe25151c2d"
  end

  resource "pyopenssl" do
    url "https://pypi.python.org/packages/source/p/pyOpenSSL/pyOpenSSL-0.15.1.tar.gz"
    sha256 "f0a26070d6db0881de8bcc7846934b7c3c930d8f9c79d45883ee48984bc0d672"
  end

  def install
    ENV.prepend_create_path "PYTHONPATH", libexec/"vendor/lib/python2.7/site-packages"
    ENV.minimal_optimization if MacOS.version <= :snow_leopard

    resources.each do |r|
      r.stage do
        system "python", *Language::Python.setup_install_args(libexec/"vendor")
      end
    end

    ENV.prepend_create_path "PYTHONPATH", libexec/"lib/python2.7/site-packages"
    system "make", "PREFIX=#{libexec}", "install-bin"
    bin.install Dir["#{libexec}/bin/*"]
    bin.env_script_all_files(libexec/"bin", :PYTHONPATH => ENV["PYTHONPATH"])

    # Install man pages, which come pre-built in source releases
    man1.install "doc/hg.1"
    man5.install "doc/hgignore.5", "doc/hgrc.5"

    # install the completion scripts
    bash_completion.install "contrib/bash_completion" => "hg-completion.bash"
    zsh_completion.install "contrib/zsh_completion" => "_hg"
  end

  test do
    system "#{bin}/hg", "init"
  end
end
