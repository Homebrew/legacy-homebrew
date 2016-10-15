class Txtorcon < Formula
  homepage "http://txtorcon.readthedocs.org/en/latest/"
  url "https://pypi.python.org/packages/source/t/txtorcon/txtorcon-0.12.0.tar.gz"
  sha256 "206b1bd8a840119c12d9b85d638ab9defec5b376436fa36be9139ab1ebc8cd78"

  depends_on :python => :recommended

  resource "Twisted" do
    url "https://pypi.python.org/packages/source/T/Twisted/Twisted-15.1.0.tar.bz2"
    sha256 "82025d24cee178a7328a0467240bb6b1e7c283a9d85f115a9872dfcbfe20732a"
  end

  resource "zope.interface" do
    url "https://pypi.python.org/packages/source/z/zope.interface/zope.interface-4.1.2.tar.gz"
    sha256 "441fefcac1fbac57c55239452557d3598571ab82395198b2565a29d45d1232f6"
  end

  def install
    resources.each do |r|
      r.stage do
        system "python", *Language::Python.setup_install_args(prefix)
      end
    end
    system "python", *Language::Python.setup_install_args(prefix)
  end

  test do
  end
end
