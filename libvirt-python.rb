class LibvirtPython < Formula
  desc "Python bindings for libvirt"
  homepage "http://www.libvirt.org"
  url "http://libvirt.org/sources/python/libvirt-python-1.3.1.tar.gz"
  sha256 "7143b922a9bd66a5e199b13316fa4266cbffc23db01c99bce37216a1eb9118f7"
  head "git://libvirt.org/libvirt-python.git"

  depends_on "pkg-config" => :build

  depends_on "libvirt"
  depends_on "python"

  def install
    system "python", "setup.py", "install", "--prefix=#{prefix}"
  end

  test do
    system "python", "-c", "import libvirt; print(libvirt.getVersion())"
  end
end
