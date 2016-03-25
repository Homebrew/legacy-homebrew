class Puddletag < Formula
  desc "Powerful, simple, audio tag editor."
  homepage "http://puddletag.sf.net"
  url "https://github.com/keithgg/puddletag/archive/1.1.1.tar.gz"
  sha256 "550680abf9c2cf082861dfb3b61fd308f87f9ed304065582cddadcc8bdd947cc"
  revision 2

  head "https://github.com/keithgg/puddletag.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "2f97b0687f8eacab3188d6e2ec595f267f862efed2701e51b39a2bf81bf508bb" => :el_capitan
    sha256 "80ad92bbf1cdaaed786063b7fc2ef78e1b652a70efbc882e1fd2c5828e3d302d" => :yosemite
    sha256 "52b3b94916fe4943df8962f63534093a7f9a9b7f6c5e0ed4869d23b51ccd908f" => :mavericks
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
