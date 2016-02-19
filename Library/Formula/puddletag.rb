class Puddletag < Formula
  desc "Powerful, simple, audio tag editor."
  homepage "http://puddletag.sf.net"
  url "https://github.com/keithgg/puddletag/archive/1.1.1.tar.gz"
  sha256 "550680abf9c2cf082861dfb3b61fd308f87f9ed304065582cddadcc8bdd947cc"
  revision 2

  head "https://github.com/keithgg/puddletag.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "66b9869de0ed08574b572ec748a9d60818793dc89786b8881186b1b9f7c49271" => :el_capitan
    sha256 "a71ba99dda619b47191d6491a4af6985db4ea8b8553a9a0a058162f5c0f4be82" => :yosemite
    sha256 "d68cf36675cb2a2ed03630d01d418199cef90fcda6d39e733d5754acb6255e51" => :mavericks
  end

  depends_on :python if MacOS.version <= :snow_leopard
  depends_on "pyqt"
  depends_on "chromaprint" => :recommended

  resource "pyparsing" do
    url "https://pypi.python.org/packages/source/p/pyparsing/pyparsing-2.1.0.tar.gz"
    sha256 "f6cb2bc85a491347c3c699db47f7ecc02903959156b4f92669ebf82395982901"
  end

  resource "mutagen" do
    url "https://bitbucket.org/lazka/mutagen/downloads/mutagen-1.31.tar.gz"
    sha256 "0aa011707785fe30935d8655380052a20ba8b972aa738d4f144c457b35b4d699"
  end

  resource "configobj" do
    url "https://pypi.python.org/packages/source/c/configobj/configobj-5.0.6.tar.gz"
    sha256 "a2f5650770e1c87fb335af19a9b7eb73fc05ccf22144eb68db7d00cd2bcb0902"
  end

  def install
    ENV.prepend_create_path "PYTHONPATH", libexec/"vendor/lib/python2.7/site-packages"
    %w[pyparsing mutagen configobj].each do |r|
      resource(r).stage do
        system "python", *Language::Python.setup_install_args(libexec/"vendor")
      end
    end

    cp_r buildpath/"source/.", buildpath

    ENV.prepend_create_path "PYTHONPATH", libexec/"lib/python2.7/site-packages"
    system "python", *Language::Python.setup_install_args(libexec)

    ENV.prepend_create_path "PYTHONPATH", HOMEBREW_PREFIX/"lib/python2.7/site-packages"

    bin.install Dir[libexec/"bin/*"]
    bin.env_script_all_files(libexec/"bin", :PATH => "#{HOMEBREW_PREFIX}/bin", :PYTHONPATH => ENV["PYTHONPATH"])

    system "sh", "create_macos_app_bundle.sh", "--name", "Puddletag",
                 "--icon", "puddletag.png", "--script", "#{bin}/puddletag"
    prefix.install "Puddletag.app"
  end

  test do
    Pathname("test.py").write <<-EOS.undent
      import puddlestuff
    EOS

    ENV.prepend_create_path "PYTHONPATH", libexec/"lib/python2.7/site-packages"
    system "python", "test.py"
  end
end
