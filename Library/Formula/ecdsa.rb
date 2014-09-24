require "formula"

class Ecdsa < Formula
  homepage "https://github.com/warner/python-ecdsa"
  url "https://pypi.python.org/packages/source/e/ecdsa/ecdsa-0.11.tar.gz"
  sha256 "8e3b6c193f91dc94b2f3b0261e3eabbdc604f78ff99fdad324a56fdd0b5e958c"

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
