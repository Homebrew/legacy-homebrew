class Moose < Formula
  desc "MOOSE is a Multiscale Object Oriented Simulation Environment for simulating multiscale neural systems."
  version "3.0.2"
  homepage "http://moose.ncbs.res.in"
  url "https://github.com/BhallaLab/moose-core/archive/ghevar-3.0.2-alpha.zip"
  sha256 "febc7fc41a2513aeb2b6998731f61c7e7f2a6b5169a77e1612c189779fb0d1f1"

  depends_on "cmake" => :build
  depends_on "gsl" 
  depends_on "homebrew/science/hdf5" 
  depends_on "homebrew/science/libsbml" 
  depends_on "homebrew/python/matplotlib"
  depends_on "homebrew/python/numpy"
  depends_on "python"
  depends_on "pyqt"

  resource "gui" do
      version "0.9.0"
      url "https://github.com/BhallaLab/moose-gui/archive/0.9.0.zip"
      sha256 "7780bbbc09d754b483c769586c8e566bf83a43408e00ce66c432791fb744aa3a"
  end

  resource "examples" do
      version "0.9.0"
      url "https://github.com/BhallaLab/moose-examples/archive/0.9.0.zip"
      sha256 "6330fb610368537e61327f9fa4667caedea0d590c490e2b1c4816d9a0d5adf35"
  end

  def install
      args = std_cmake_args
      mkdir "_build" do
        system "cmake", "..", *args
        system "make"
      end

      Dir.chdir('python') {
          system "python", "setup.py", "install", "--prefix=#{prefix}"
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
end
