class Letsencrypt < Formula
  desc "Tool to automatically receive and install X.509 certificates"
  homepage "https://letsencrypt.org/"
  url "https://github.com/letsencrypt/letsencrypt/archive/v0.1.1-corrected.tar.gz"
  version "0.1.1"
  sha256 "d9efa11a90cd38bf38218e51c541978ebb836f00ede0c9c8155301ca30a55774"

  depends_on "augeas"
  depends_on "dialog"
  depends_on "openssl"
  depends_on :python if MacOS.version <= :snow_leopard

  resource "setuptools" do
    url "https://pypi.python.org/packages/source/s/setuptools/setuptools-18.7.1.tar.gz"
    sha256 "aff36c95035e0b311eacb1434e3f7e85f5ccaad477773847e582978f8f45bd74"
  end

  resource "cffi" do
    url "https://pypi.python.org/packages/source/c/cffi/cffi-1.3.1.tar.gz"
    sha256 "d45dd39a770b4afb591c82555f6a8bbc1ac7eb019eda9b621eee1a0a72201220"
  end

  resource "ConfigArgParse" do
    url "https://pypi.python.org/packages/source/C/ConfigArgParse/ConfigArgParse-0.10.0.tar.gz"
    sha256 "3b50a83dd58149dfcee98cb6565265d10b53e9c0a2bca7eeef7fb5f5524890a7"
  end

  resource "configobj" do
    url "https://pypi.python.org/packages/source/c/configobj/configobj-5.0.6.tar.gz"
    sha256 "a2f5650770e1c87fb335af19a9b7eb73fc05ccf22144eb68db7d00cd2bcb0902"
  end

  resource "cryptography" do
    url "https://pypi.python.org/packages/source/c/cryptography/cryptography-1.1.1.tar.gz"
    sha256 "2912923af7455fb2d2439a037242507c12caece7dd6659d62fa82a61edb2bae0"
  end

  resource "enum34" do
    url "https://pypi.python.org/packages/source/e/enum34/enum34-1.1.1.tar.gz"
    sha256 "9d4a9220e4ebabd7ff60d853e69c3dd89debad5ddeb9ac5e768af811ece7708e"
  end

  resource "funcsigs" do
    url "https://pypi.python.org/packages/source/f/funcsigs/funcsigs-0.4.tar.gz"
    sha256 "d83ce6df0b0ea6618700fe1db353526391a8a3ada1b7aba52fed7a61da772033"
  end

  resource "idna" do
    url "https://pypi.python.org/packages/source/i/idna/idna-2.0.tar.gz"
    sha256 "16199aad938b290f5be1057c0e1efc6546229391c23cea61ca940c115f7d3d3b"
  end

  resource "ipaddress" do
    url "https://pypi.python.org/packages/source/i/ipaddress/ipaddress-1.0.15.tar.gz"
    sha256 "af6c85cfc9cdb12b861655e6b9f2f59618bf3088cbde858727b2c0a98e9f6636"
  end

  resource "mock" do
    url "https://pypi.python.org/packages/source/m/mock/mock-1.3.0.tar.gz"
    sha256 "1e247dbecc6ce057299eb7ee019ad68314bb93152e81d9a6110d35f4d5eca0f6"
  end

  resource "ndg-httpsclient" do
    url "https://pypi.python.org/packages/source/n/ndg-httpsclient/ndg_httpsclient-0.4.0.tar.gz"
    sha256 "e8c155fdebd9c4bcb0810b4ed01ae1987554b1ee034dd7532d7b8fdae38a6274"
  end

  resource "parsedatetime" do
    url "https://pypi.python.org/packages/source/p/parsedatetime/parsedatetime-1.5.tar.gz"
    sha256 "3da6be2be506f59cce32e19e30e201053e1bb4d07e25668918e00f8a49ad40ab"
  end

  resource "pbr" do
    url "https://pypi.python.org/packages/source/p/pbr/pbr-1.8.1.tar.gz"
    sha256 "e2127626a91e6c885db89668976db31020f0af2da728924b56480fc7ccf09649"
  end

  resource "psutil" do
    url "https://pypi.python.org/packages/source/p/psutil/psutil-3.3.0.tar.gz"
    sha256 "421b6591d16b509aaa8d8c15821d66bb94cb4a8dc4385cad5c51b85d4a096d85"
  end

  resource "pyasn1" do
    url "https://pypi.python.org/packages/source/p/pyasn1/pyasn1-0.1.9.tar.gz"
    sha256 "853cacd96d1f701ddd67aa03ecc05f51890135b7262e922710112f12a2ed2a7f"
  end

  resource "pycparser" do
    url "https://pypi.python.org/packages/source/p/pycparser/pycparser-2.14.tar.gz"
    sha256 "7959b4a74abdc27b312fed1c21e6caf9309ce0b29ea86b591fd2e99ecdf27f73"
  end

  resource "pyOpenSSL" do
    url "https://pypi.python.org/packages/source/p/pyOpenSSL/pyOpenSSL-0.15.1.tar.gz"
    sha256 "f0a26070d6db0881de8bcc7846934b7c3c930d8f9c79d45883ee48984bc0d672"
  end

  resource "pyRFC3339" do
    url "https://pypi.python.org/packages/source/p/pyRFC3339/pyRFC3339-1.0.tar.gz"
    sha256 "8dfbc6c458b8daba1c0f3620a8c78008b323a268b27b7359e92a4ae41325f535"
  end

  resource "python-augeas" do
    url "https://pypi.python.org/packages/source/p/python-augeas/python-augeas-0.5.0.tar.gz"
    sha256 "67d59d66cdba8d624e0389b87b2a83a176f21f16a87553b50f5703b23f29bac2"
  end

  resource "python2-pythondialog" do
    url "https://pypi.python.org/packages/source/p/python2-pythondialog/python2-pythondialog-3.3.0.tar.bz2"
    sha256 "04e93f24995c43dd90f338d5d865ca72ce3fb5a5358d4daa4965571db35fc3ec"
  end

  resource "pytz" do
    url "https://pypi.python.org/packages/source/p/pytz/pytz-2015.7.tar.bz2"
    sha256 "fbd26746772c24cb93c8b97cbdad5cb9e46c86bbdb1b9d8a743ee00e2fb1fc5d"
  end

  resource "requests" do
    url "https://pypi.python.org/packages/source/r/requests/requests-2.7.0.tar.gz"
    sha256 "398a3db6d61899d25fd4a06c6ca12051b0ce171d705decd7ed5511517b4bb93d"
  end

  resource "six" do
    url "https://pypi.python.org/packages/source/s/six/six-1.10.0.tar.gz"
    sha256 "105f8d68616f8248e24bf0e9372ef04d3cc10104f1980f54d57b2ce73a5ad56a"
  end

  resource "Werkzeug" do
    url "https://pypi.python.org/packages/source/W/Werkzeug/Werkzeug-0.11.2.tar.gz"
    sha256 "eb4f98994b40a8e2edce289e811c9a38880ae53eb9ff6f031d0e243a69b0fcbf"
  end

  resource "zope.component" do
    url "https://pypi.python.org/packages/source/z/zope.component/zope.component-4.2.2.tar.gz"
    sha256 "282c112b55dd8e3c869a3571f86767c150ab1284a9ace2bdec226c592acaf81a"
  end

  resource "zope.event" do
    url "https://pypi.python.org/packages/source/z/zope.event/zope.event-4.1.0.tar.gz"
    sha256 "dc7a59a2fd91730d3793131a5d261b29e93ec4e2a97f1bc487ce8defee2fe786"
  end

  resource "zope.interface" do
    url "https://pypi.python.org/packages/source/z/zope.interface/zope.interface-4.1.3.tar.gz"
    sha256 "2e221a9eec7ccc58889a278ea13dcfed5ef939d80b07819a9a8b3cb1c681484f"
  end

  def install
    ENV.prepend_create_path "PYTHONPATH", libexec/"vendor/lib/python2.7/site-packages"

    # First install setuptools because mock requires setuptools>=17.1
    resource("setuptools").stage do
      system "python", *Language::Python.setup_install_args(libexec/"vendor")
    end

    # Then install all the rest
    resources.each do |r|
      next if r.name == "setuptools"
      r.stage do
        system "python", *Language::Python.setup_install_args(libexec/"vendor")
      end
    end

    touch libexec/"vendor/lib/python2.7/site-packages/zope/__init__.py"

    ENV.prepend_create_path "PYTHONPATH", libexec/"lib/python2.7/site-packages"

    cd "acme" do
      system "python", *Language::Python.setup_install_args(libexec)
    end

    system "python", *Language::Python.setup_install_args(libexec)

    cd "letsencrypt-apache" do
      system "python", *Language::Python.setup_install_args(libexec)
    end

    bin.install Dir[libexec/"bin/*"]
    bin.env_script_all_files(libexec/"bin", :PYTHONPATH => ENV["PYTHONPATH"])
  end

  test do
    assert_match "#{version}", shell_output("#{bin}/letsencrypt --version 2>&1")
  end
end
