require "formula"

class Pycrypto < Formula
  homepage "https://www.dlitz.net/software/pycrypto/"
  url "https://pypi.python.org/packages/source/p/pycrypto/pycrypto-2.6.1.tar.gz"
  sha256 "f2ce1e989b272cfcb677616763e0a2e7ec659effa67a88aa92b3a65528f60a3c"

  depends_on :python

  def install
    ENV["PYTHONPATH"] = lib+"python2.7/site-packages"
    ENV.prepend_create_path 'PYTHONPATH', libexec+'lib/python2.7/site-packages'
    system "python", "setup.py", "install", "--prefix=#{prefix}"
    bin.env_script_all_files(libexec+'bin', :PYTHONPATH => ENV['PYTHONPATH'])
  end

  test do
    false
  end
end
