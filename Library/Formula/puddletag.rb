class Puddletag < Formula
  desc "Powerful, simple, audio tag editor."
  homepage "http://puddletag.sf.net"
  url "https://github.com/keithgg/puddletag/archive/1.1.1.tar.gz"
  sha256 "550680abf9c2cf082861dfb3b61fd308f87f9ed304065582cddadcc8bdd947cc"

  head "https://github.com/keithgg/puddletag.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "c2d91ff12bef60fd87a560132c962164939dbb08aa518efaaf8f5b974c869ef0" => :el_capitan
    sha256 "ca24eaa710ec6422ae3998b7496be25cf36f8c750686cc0ecbb2d3787ec6fa4f" => :yosemite
    sha256 "4501e1d867b8f889da17b8f6e4ad8155c436b7ee54bf9510c16a5a3f78866765" => :mavericks
  end

  depends_on :python if MacOS.version <= :snow_leopard
  depends_on "pyqt"
  depends_on "chromaprint" => :recommended

  resource "pyparsing" do
    url "https://pypi.python.org/packages/source/p/pyparsing/pyparsing-1.5.7.tar.gz"
    sha256 "646e14f90b3689b005c19ac9b6b390c9a39bf976481849993e277d7380e6e79f"
  end

  resource "mutagen" do
    url "https://bitbucket.org/lazka/mutagen/downloads/mutagen-1.21.tar.gz"
    sha256 "4dd30af3a291c0a152838f2bbf1d592bf6ede752b11a159cbf84e75815bcc2b5"
  end

  resource "configobj" do
    url "https://pypi.python.org/packages/source/c/configobj/configobj-5.0.5.tar.gz"
    sha256 "766eff273f2cbb007a3ea8aa69429ee9b1553aa96fe282c6ace3769b9ac47b08"
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
    bin.env_script_all_files(libexec/"bin", :PYTHONPATH => ENV["PYTHONPATH"])

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
