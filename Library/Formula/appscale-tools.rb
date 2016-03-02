class AppscaleTools < Formula
  desc "Command-line tools for working with AppScale"
  homepage "https://github.com/AppScale/appscale-tools"
  url "https://github.com/AppScale/appscale-tools/archive/2.7.1.tar.gz"
  sha256 "d7ac9ec391d480a16dbaff80bdbb4b308a0e170be220ba423c33bf80246eb31e"
  head "https://github.com/AppScale/appscale-tools.git"

  bottle do
    cellar :any
    revision 1
    sha256 "c345579e07945ba1aa25adb524da5b411dca1b142d7ed6a28ccb2733aa035348" => :el_capitan
    sha256 "29df09087360c2479b6cf9539298bdd7e640b486827a43373221b931ab98a39f" => :yosemite
    sha256 "1052b6c7a32db1bf74f9e6818c9953dfd77a4bf453054c4791606ee6fa9a08ea" => :mavericks
  end

  depends_on :python if MacOS.version <= :snow_leopard
  depends_on "libyaml"
  depends_on "ssh-copy-id"

  resource "termcolor" do
    url "https://pypi.python.org/packages/source/t/termcolor/termcolor-1.1.0.tar.gz"
    sha256 "1d6d69ce66211143803fbc56652b41d73b4a400a2891d7bf7a1cdf4c02de613b"
  end

  resource "SOAPpy" do
    url "https://pypi.python.org/packages/source/S/SOAPpy/SOAPpy-0.12.22.zip"
    sha256 "e70845906bb625144ae6a8df4534d66d84431ff8e21835d7b401ec6d8eb447a5"
  end

  # dependencies for soappy
  resource "wstools" do
    url "https://pypi.python.org/packages/source/w/wstools/wstools-0.4.3.tar.gz"
    sha256 "578b53e98bc8dadf5a55dfd1f559fd9b37a594609f1883f23e8646d2d30336f8"
  end
  resource "defusedxml" do
    url "https://pypi.python.org/packages/source/d/defusedxml/defusedxml-0.4.1.tar.gz"
    sha256 "cd551d5a518b745407635bb85116eb813818ecaf182e773c35b36239fc3f2478"
  end

  resource "pyyaml" do
    url "https://pypi.python.org/packages/source/P/PyYAML/PyYAML-3.11.tar.gz"
    sha256 "c36c938a872e5ff494938b33b14aaa156cb439ec67548fcab3535bb78b0846e8"
  end

  resource "boto" do
    url "https://pypi.python.org/packages/source/b/boto/boto-2.39.0.tar.gz"
    sha256 "950c5bf36691df916b94ebc5679fed07f642030d39132454ec178800d5b6c58a"
  end

  resource "argparse" do
    url "https://pypi.python.org/packages/source/a/argparse/argparse-1.3.0.tar.gz"
    sha256 "b3a79a23d37b5a02faa550b92cbbbebeb4aa1d77e649c3eb39c19abf5262da04"
  end

  resource "google-api-python-client" do
    url "https://pypi.python.org/packages/source/g/google-api-python-client/google-api-python-client-1.5.0.tar.gz"
    sha256 "ffb89782c74702bd47d217709741717f0e4812d87f6cea04783f991d3eb51abd"
  end

  # dependencies for google-api-python-client
  resource "oauth2client" do
    url "https://pypi.python.org/packages/source/o/oauth2client/oauth2client-2.0.0.post1.tar.gz"
    sha256 "eb14cfe72f0af2b3bbb7c1da3f0f781b61ed89b31e4282313220746798aa7bdd"
  end

  # dependencies for oauth2client
  resource "pyasn1" do
    url "https://pypi.python.org/packages/source/p/pyasn1/pyasn1-0.1.9.tar.gz"
    sha256 "853cacd96d1f701ddd67aa03ecc05f51890135b7262e922710112f12a2ed2a7f"
  end
  resource "pyasn1-modules" do
    url "https://pypi.python.org/packages/source/p/pyasn1-modules/pyasn1-modules-0.0.8.tar.gz"
    sha256 "10561934f1829bcc455c7ecdcdacdb4be5ffd3696f26f468eb6eb41e107f3837"
  end
  resource "rsa" do
    url "https://pypi.python.org/packages/source/r/rsa/rsa-3.3.tar.gz"
    sha256 "03f3d9bebad06681771016b8752a40b12f615ff32363c7aa19b3798e73ccd615"
  end

  resource "six" do
    url "https://pypi.python.org/packages/source/s/six/six-1.10.0.tar.gz"
    sha256 "105f8d68616f8248e24bf0e9372ef04d3cc10104f1980f54d57b2ce73a5ad56a"
  end
  resource "uritemplate" do
    url "https://pypi.python.org/packages/source/u/uritemplate/uritemplate-0.6.tar.gz"
    sha256 "a30e230aeb7ebedbcb5da9999a17fa8a30e512e6d5b06f73d47c6e03c8e357fd"
  end

  resource "httplib2" do
    url "https://pypi.python.org/packages/source/h/httplib2/httplib2-0.9.2.tar.gz"
    sha256 "c3aba1c9539711551f4d83e857b316b5134a1c4ddce98a875b7027be7dd6d988"
  end

  def install
    ENV.prepend_create_path "PYTHONPATH", libexec/"vendor/lib/python2.7/site-packages"
    resources.each do |r|
      r.stage do
        system "python", *Language::Python.setup_install_args(libexec/"vendor")
      end
    end

    ENV.prepend_create_path "PYTHONPATH", libexec/"lib/python2.7/site-packages"
    system "python", *Language::Python.setup_install_args(libexec)

    bin.install Dir[libexec/"bin/*"]
    bin.env_script_all_files(libexec/"bin", :PYTHONPATH => ENV["PYTHONPATH"])
  end

  test do
    system bin/"appscale", "help"
    system bin/"appscale", "init", "cloud"
  end
end
