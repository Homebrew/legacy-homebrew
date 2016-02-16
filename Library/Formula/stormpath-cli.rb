class StormpathCli < Formula
  desc "Command-line interface for https://stormpath.com/ user management"
  homepage "https://github.com/stormpath/stormpath-cli"
  url "https://github.com/stormpath/stormpath-cli/archive/0.0.2.tar.gz"
  sha256 "50e334cb48cd0f9c0abdf77c1aa577c1d900547d8be39155d2248b995c044b0e"
  head "https://github.com/stormpath/stormpath-cli.git"

  depends_on :python if MacOS.version <= :snow_leopard

  resource "docopt" do
    url "https://pypi.python.org/packages/source/d/docopt/docopt-0.6.2.tar.gz"
    sha256 "49b3a825280bd66b3aa83585ef59c4a8c82f2c8a522dbe754a8bc8d08c85c491"
  end

  resource "stormpath" do
    url "https://pypi.python.org/packages/source/s/stormpath/stormpath-2.1.6.tar.gz"
    sha256 "48e6f30b50a04678be80dd759237188adea108a29ebbf1343b64bead22bafb17"
  end

  resource "pyjwt" do
    url "https://pypi.python.org/packages/source/P/PyJWT/PyJWT-1.4.0.tar.gz"
    sha256 "e1b2386cfad541445b1d43e480b02ca37ec57259fd1a23e79415b57ba5d8a694"
  end

  resource "oauthlib" do
    url "https://pypi.python.org/packages/source/o/oauthlib/oauthlib-1.0.3.tar.gz"
    sha256 "ef4bfe4663ca3b97a995860c0173b967ebd98033d02f38c9e1b2cbb6c191d9ad"
  end

  resource "requests" do
    url "https://pypi.python.org/packages/source/r/requests/requests-2.9.1.tar.gz"
    sha256 "c577815dd00f1394203fc44eb979724b098f88264a9ef898ee45b8e5e9cf587f"
  end

  resource "six" do
    url "https://pypi.python.org/packages/source/s/six/six-1.10.0.tar.gz"
    sha256 "105f8d68616f8248e24bf0e9372ef04d3cc10104f1980f54d57b2ce73a5ad56a"
  end

  resource "python-dateutil" do
    url "https://pypi.python.org/packages/source/p/python-dateutil/python-dateutil-2.4.2.tar.gz"
    sha256 "3e95445c1db500a344079a47b171c45ef18f57d188dffdb0e4165c71bea8eb3d"
  end

  resource "pydispatcher" do
    url "https://pypi.python.org/packages/source/P/PyDispatcher/PyDispatcher-2.0.5.tar.gz"
    sha256 "5570069e1b1769af1fe481de6dd1d3a388492acddd2cdad7a3bde145615d5caf"
  end

  resource "isodate" do
    url "https://pypi.python.org/packages/source/i/isodate/isodate-0.5.4.tar.gz"
    sha256 "42105c41d037246dc1987e36d96f3752ffd5c0c24834dd12e4fdbe1e79544e31"
  end

  def install
    ENV.prepend_create_path "PYTHONPATH", libexec/"vendor/lib/python2.7/site-packages"
    %w[docopt stormpath pyjwt oauthlib requests six python-dateutil pydispatcher isodate].each do |r|
      resource(r).stage do
        system "python", *Language::Python.setup_install_args(libexec/"vendor")
      end
    end

    ENV.prepend_create_path "PYTHONPATH", libexec/"lib/python2.7/site-packages"
    system "python", *Language::Python.setup_install_args(libexec)

    bin.install Dir["#{libexec}/bin/*"]
    bin.env_script_all_files(libexec/"bin", :PYTHONPATH => ENV["PYTHONPATH"])
  end

  test do
    system "#{bin}/stormpath", "--help"
  end
end
