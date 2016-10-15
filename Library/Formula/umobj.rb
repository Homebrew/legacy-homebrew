class Umobj < Formula
  desc "Command-line utilties for S3-compatible Object Storage"
  homepage "https://github.com/UMIACS/umobj"
  url "https://pypi.python.org/packages/source/u/umobj/umobj-1.2.0.tar.gz"
  sha256 "cacc2efe07b069660df595b409afc16639d96856ec9954c105b95358553d3add"

  head "https://github.com/UMIACS/umobj.git"

  depends_on :python if MacOS.version <= :snow_leopard

  resource "netaddr" do
    url "https://pypi.python.org/packages/source/n/netaddr/netaddr-0.7.15.tar.gz"
    sha256 "d5b5bb3f4e9a94f93d232bb876e567517d8fb59e5bebb5339483b44df5529d11"
  end

  resource "qav" do
    url "https://pypi.python.org/packages/source/q/qav/qav-0.3.2.tar.gz"
    sha256 "4e16d4544451f200689a2ae6908b14669f9f2a4a8881368d78e609196fbdee84"
  end

  resource "boto" do
    url "https://pypi.python.org/packages/source/b/boto/boto-2.38.0.tar.gz"
    sha256 "d9083f91e21df850c813b38358dc83df16d7f253180a1344ecfedce24213ecf2"
  end

  resource "filechunkio" do
    url "https://pypi.python.org/packages/source/f/filechunkio/filechunkio-1.6.tar.gz"
    sha256 "163948052cd274daddfcde9cec9cb5e04ac19d7bb91606cdc6a305b0428a0e70"
  end

  resource "progressbar" do
    url "https://pypi.python.org/packages/source/p/progressbar/progressbar-2.3.tar.gz"
    sha256 "b2d38a729785149e65323381d2e6fca0a5e9615a6d8bcf10bfa8adedfc481254"
  end

  def install
    ENV.prepend_create_path "PYTHONPATH", libexec/"vendor/lib/python2.7/site-packages"
    %w[netaddr qav boto filechunkio progressbar].each do |r|
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
    system "#{bin}/lsobj", "--help"
    system "#{bin}/mkobj", "--help"
    system "#{bin}/cpobj", "--help"
    system "#{bin}/rmobj", "--help"
    system "#{bin}/chobj", "--help"
    system "#{bin}/catobj", "--help"
    system "#{bin}/syncobj", "--help"
  end
end
