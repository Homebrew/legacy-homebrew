class Stem < Formula
  homepage "https://stem.torproject.org/"
  url "https://pypi.python.org/packages/source/s/stem/stem-1.3.0.tar.bz2"
  sha256 "770e370156e0e92a9862e4670ee3f4ac385742006e578608528ee16cbab9d416"

  depends_on :python if MacOS.version <= :snow_leopard
  depends_on :python3 => :optional
  option "with-pycrypto", "Build with pycrypto support"

  resource "pycrypto" do
    url "https://pypi.python.org/packages/source/p/pycrypto/pycrypto-2.6.1.tar.gz"
    sha256 "f2ce1e989b272cfcb677616763e0a2e7ec659effa67a88aa92b3a65528f60a3c"
  end

  def install
    if build.with? "pycrypto"
      resource("pycrypto").stage do
        system "python", *Language::Python.setup_install_args(prefix)
      end
    end
    system "python", *Language::Python.setup_install_args(prefix)
  end

  test do
    # Test stem version.
    (testpath/"test.py").write <<-EOS.undent
      import stem
      import unittest
      class TestStem(unittest.TestCase):
        def test_stem_version(self):
          self.assertEqual(stem.__version__, '1.3.0')

      if __name__ == '__main__':
        unittest.main()
    EOS
    system "python", "test.py"
  end
end
