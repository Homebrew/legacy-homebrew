class Moose < Formula
  desc "Multiscale Object Oriented Simulation Environment for  multiscale neural systems."
  homepage "http://moose.ncbs.res.in"
  url "https://github.com/BhallaLab/moose-core/archive/ghevar-3.0.2-alpha.tar.gz"
  sha256 "febc7fc41a2513aeb2b6998731f61c7e7f2a6b5169a77e1612c189779fb0d1f1"

  depends_on "cmake" => :build
  depends_on "gsl"
  depends_on "homebrew/science/hdf5"
  depends_on "homebrew/science/libsbml" => :optional
  depends_on "homebrew/python/matplotlib"
  depends_on "homebrew/python/numpy"
  depends_on "python" if MacOS.version <= :snow_leopard
  depends_on "pyqt"

  resource "gui" do
    url "https://github.com/BhallaLab/moose-gui/archive/0.9.0.tar.gz"
    sha256 "febc7fc41a2513aeb2b6998731f61c7e7f2a6b5169a77e1612c189779fb0d1f1"
  end

  resource "examples" do
    url "https://github.com/BhallaLab/moose-examples/archive/0.9.0.tar.gz"
    sha256 "6330fb610368537e61327f9fa4667caedea0d590c490e2b1c4816d9a0d5adf35"
  end

  def install
    mkdir "_build" do
      system "cmake", "..", *std_cmake_args
      system "make"
    end

    Dir.cd("python") {
      #system "python", "setup.py", "install", "--prefix=#{prefix}"
      system "python", *Language::Python.setup_install_args(prefix)
    }

    libexec.install resource("gui")
    doc.install resource("examples")

    # A wrapper script to launch moose gui.
    (bin/"moosegui").write <<-EOS.undent
      #!/bin/bash
      BASEDIR="#{libexec}"
      (cd $BASEDIR && python mgui.py)
    EOS
    chmod 0755, bin/"moosegui"

    bin.env_script_all_files(libexec+"bin", :PYTHONPATH => ENV["PYTHONPATH"])
  end

  def test
    Dir.cd("tests/python") {
      system "bash", "./test_all.sh"
    }
  end

end
