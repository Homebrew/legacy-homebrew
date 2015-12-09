class Puddletag < Formula
  desc "Powerful, simple, audio tag editor."
  homepage "http://puddletag.sf.net"
  url "https://github.com/keithgg/puddletag/archive/v1.0.5.tar.gz"
  sha256 "f94ebcc4ed31389574c187197b99256bec1f96e1e7d4dd61730e88f79deeaba2"
  revision 1

  head "https://github.com/keithgg/puddletag.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "3ae286958269cf2bdc8e529226489910a05a64f1f8cfe6bc3d4884cd53d9b65e" => :el_capitan
    sha256 "6f54a307e0b0bf717b622c6f33cb4b7b82fa7f3ce9b8e90f1065500c360783cd" => :yosemite
    sha256 "402eb5c665befc57cf7eb2566d53ce99e0b16dcae0321c6b70bec3aad3032667" => :mavericks
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

  # Upstream commit to fix an issue with PyQT 4.11.4. Remove on next version.
  patch do
    url "https://github.com/keithgg/puddletag/commit/489acd2ee62eb5fbff95f8220dc8958c14871931.patch"
    sha256 "fce0cfce4d4477cde4827a0a4d3ef74fbabf630ada2d0cf035cf155a17c37a68"
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
  end

  test do
    Pathname("test.py").write <<-EOS.undent
      import puddlestuff
    EOS

    ENV.prepend_create_path "PYTHONPATH", libexec/"lib/python2.7/site-packages"
    system "python", "test.py"
  end
end
