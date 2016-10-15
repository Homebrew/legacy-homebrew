require "formula"

class Paramiko < Formula
  homepage "http://www.paramiko.org/"
  url "https://pypi.python.org/packages/source/p/paramiko/paramiko-1.15.1.tar.gz"
  sha256 "6ed97e2281bb48728692cdc621f6b86a65fdc1d46b178ce250cfec10b977a04c"

  depends_on :python
  depends_on :pycrypto

  def install
    ENV["PYTHONPATH"] = lib+"python2.7/site-packages"
    ENV.prepend_create_path 'PYTHONPATH', libexec+'lib/python2.7/site-packages'
    system "python", "setup.py", "install", "--single-version-externally-managed", "--record=installed.txt",
      "--prefix=#{prefix}"
    bin.env_script_all_files(libexec+'bin', :PYTHONPATH => ENV['PYTHONPATH'])
  end

  test do
    false
  end
end
