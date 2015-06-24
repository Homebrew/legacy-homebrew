class CpyritOpencl < Formula
  desc "OpenCL support for Pyrit."
  homepage "https://code.google.com/p/pyrit/wiki/Installation"
  url "https://pyrit.googlecode.com/files/cpyrit-opencl-0.4.0.tar.gz"
  sha256 "aac593bce3f00ea7fd3d558083dbd7e168332a92736e51a621a0459d1bc042fa"

  depends_on :python
  depends_on 'pyrit'

  def install
    system "python", "setup.py", "build"
    system "python", "setup.py", "install", "--prefix=#{prefix}"
  end

end
