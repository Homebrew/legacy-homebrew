class Treeline < Formula
  desc "Advanced outliner and personal information manager"
  homepage "http://treeline.bellz.org/"
  url "https://downloads.sourceforge.net/project/treeline/2.0.0/treeline-2.0.0.tar.gz"
  sha256 "71af995fca9e0eaf4e6205d72eb4ee6a979a45ea2a1f6600ed8a39bb1861d118"
  revision 1

  bottle do
    cellar :any_skip_relocation
    sha256 "292a2f76368f62cac0e30698e4817763c962e112bf28f799ea4a62f67f2c8a11" => :yosemite
    sha256 "ccbdeb9e8281c23fd1bf0f3d6797e683b2d7e57434dff5b8deaca0f54cb2779f" => :mavericks
    sha256 "ce5b00951f652fcc4e992e7b4509b83995203a2a66f6fe6b3a7df503620bfff2" => :mountain_lion
  end

  depends_on :python3
  depends_on "sip" => "with-python3"
  depends_on "pyqt" => "with-python3"

  def install
    pyver = Language::Python.major_minor_version "python3"
    ENV.delete "PYTHONPATH"
    %w[sip pyqt].each do |f|
      ENV.append_path "PYTHONPATH", "#{Formula[f].opt_lib}/python#{pyver}/site-packages"
    end

    system "./install.py", "-p#{libexec}"
    bin.install Dir[libexec/"bin/*"]
    bin.env_script_all_files(libexec/"bin", :PYTHONPATH => ENV["PYTHONPATH"])
  end

  test do
    system bin/"treeline", "--help"
  end
end
