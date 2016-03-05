class Letsencrypt < Formula
  desc "Tool to automatically receive and install X.509 certificates"
  homepage "https://letsencrypt.org/"
  url "https://github.com/letsencrypt/letsencrypt/archive/v0.4.2.tar.gz"
  sha256 "0f55c0f292829a9c6c1da7a57860290285cfa5da8615a87b8c268a946ab656b2"

  bottle do
    cellar :any
    sha256 "8631713f5fc5e75175f9e29023f78df552424ce8e96eec4f298a71e83d60bf0c" => :el_capitan
    sha256 "d2d7ca7a003a04d923bcb83742cfefaaa50e534517a07e87ead9df8089b6af1a" => :yosemite
    sha256 "8f7e29608bc8e7ad04a8f3411851369b9ad746bc49074644be2404ba2aa8fd01" => :mavericks
  end

  depends_on "augeas"
  depends_on "dialog"
  depends_on "openssl"
  depends_on :python if MacOS.version <= :snow_leopard

  resource "setuptools" do
    url "https://pypi.python.org/packages/source/s/setuptools/setuptools-19.4.tar.gz"
    sha256 "214bf29933f47cf25e6faa569f710731728a07a19cae91ea64f826051f68a8cf"
  end

  resource "cffi" do
    url "https://pypi.python.org/packages/source/c/cffi/cffi-1.5.2.tar.gz"
    sha256 "da9bde99872e46f7bb5cff40a9b1cc08406765efafb583c704de108b6cb821dd"
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
    url "https://pypi.python.org/packages/source/c/cryptography/cryptography-1.2.3.tar.gz"
    sha256 "8eb11c77dd8e73f48df6b2f7a7e16173fe0fe8fdfe266232832e88477e08454e"
  end

  resource "enum34" do
    url "https://pypi.python.org/packages/source/e/enum34/enum34-1.1.2.tar.gz"
    sha256 "2475d7fcddf5951e92ff546972758802de5260bf409319a9f1934e6bbc8b1dc7"
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
    url "https://pypi.python.org/packages/source/i/ipaddress/ipaddress-1.0.16.tar.gz"
    sha256 "5a3182b322a706525c46282ca6f064d27a02cffbd449f9f47416f1dc96aa71b0"
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
    url "https://pypi.python.org/packages/source/p/psutil/psutil-4.0.0.tar.gz"
    sha256 "1a7c672f9ee79c84ff16b8de6f6040080f0e25002ac47f115f4a54aa88e5cfcd"
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

  resource "python2-pythondialog" do
    url "https://pypi.python.org/packages/source/p/python2-pythondialog/python2-pythondialog-3.3.0.tar.bz2"
    sha256 "04e93f24995c43dd90f338d5d865ca72ce3fb5a5358d4daa4965571db35fc3ec"
  end

  resource "pytz" do
    url "https://pypi.python.org/packages/source/p/pytz/pytz-2015.7.tar.bz2"
    sha256 "fbd26746772c24cb93c8b97cbdad5cb9e46c86bbdb1b9d8a743ee00e2fb1fc5d"
  end

  resource "requests" do
    url "https://pypi.python.org/packages/source/r/requests/requests-2.9.1.tar.gz"
    sha256 "c577815dd00f1394203fc44eb979724b098f88264a9ef898ee45b8e5e9cf587f"
  end

  resource "six" do
    url "https://pypi.python.org/packages/source/s/six/six-1.10.0.tar.gz"
    sha256 "105f8d68616f8248e24bf0e9372ef04d3cc10104f1980f54d57b2ce73a5ad56a"
  end

  resource "zope.component" do
    url "https://pypi.python.org/packages/source/z/zope.component/zope.component-4.2.2.tar.gz"
    sha256 "282c112b55dd8e3c869a3571f86767c150ab1284a9ace2bdec226c592acaf81a"
  end

  resource "zope.event" do
    url "https://pypi.python.org/packages/source/z/zope.event/zope.event-4.2.0.tar.gz"
    sha256 "ce11004217863a4827ea1a67a31730bddab9073832bdb3b9be85869259118758"
  end

  resource "zope.interface" do
    url "https://pypi.python.org/packages/source/z/zope.interface/zope.interface-4.1.3.tar.gz"
    sha256 "2e221a9eec7ccc58889a278ea13dcfed5ef939d80b07819a9a8b3cb1c681484f"
  end

  # Required because augeas formula doesn't ship these.
  resource "python-augeas" do
    url "https://pypi.python.org/packages/source/p/python-augeas/python-augeas-0.5.0.tar.gz"
    sha256 "67d59d66cdba8d624e0389b87b2a83a176f21f16a87553b50f5703b23f29bac2"
  end

  # Required for the nginx module.
  resource "pyparsing" do
    url "https://pypi.python.org/packages/source/p/pyparsing/pyparsing-2.1.0.tar.gz"
    sha256 "f6cb2bc85a491347c3c699db47f7ecc02903959156b4f92669ebf82395982901"
  end

  def install
    ENV.prepend_create_path "PYTHONPATH", libexec/"vendor/lib/python2.7/site-packages"
    resources.each do |r|
      r.stage do
        system "python", *Language::Python.setup_install_args(libexec/"vendor")
      end
    end

    # Namespace packages and .pth files aren't processed from PYTHONPATH.
    touch libexec/"vendor/lib/python2.7/site-packages/zope/__init__.py"
    touch libexec/"vendor/lib/python2.7/site-packages/ndg/__init__.py"

    cd "acme" do
      system "python", *Language::Python.setup_install_args(libexec)
    end

    ENV.prepend_create_path "PYTHONPATH", libexec/"lib/python2.7/site-packages"
    system "python", *Language::Python.setup_install_args(libexec)

    cd "letsencrypt-apache" do
      system "python", *Language::Python.setup_install_args(libexec)
    end

    cd "letsencrypt-nginx" do
      system "python", *Language::Python.setup_install_args(libexec)
    end

    bin.install Dir[libexec/"bin/*"]
    bin.env_script_all_files(libexec/"bin", :PYTHONPATH => ENV["PYTHONPATH"])
  end

  test do
    assert_match version.to_s, pipe_output("#{bin}/letsencrypt --version 2>&1")
  end
end
