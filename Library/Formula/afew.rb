class Afew < Formula
  desc "afew is an initial tagging script for notmuch."
  homepage "https://github.com/teythoon/afew"
  head "https://github.com/teythoon/afew.git"

  depends_on :python if MacOS.version <= :snow_leopard
  depends_on "notmuch" => ["with-python"]
  depends_on "dbacl"
  depends_on "emacs" => :optional

  resource "chardet" do
    url "https://pypi.python.org/packages/source/c/chardet/chardet-2.3.0.tar.gz"
    sha256 "e53e38b3a4afe6d1132de62b7400a4ac363452dc5dfcf8d88e8e0cce663c68aa"
  end

  resource "subprocess32" do
    url "https://pypi.python.org/packages/source/s/subprocess32/subprocess32-3.2.6.tar.gz"
    sha256 "ddf4d46ed2be2c7e7372dfd00c464cabb6b3e29ca4113d85e26f82b3d2c220f6"
  end

  def install
    ENV.prepend_create_path "PYTHONPATH", libexec/"vendor/lib/python2.7/site-packages"
    %w[chardet subprocess32].each do |r|
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
    system "#{bin}/afew", "--help"
  end
end
