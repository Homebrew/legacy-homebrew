require "formula"

class Fabric < Formula
  homepage "http://www.fabfile.org/index.html"
  url "https://pypi.python.org/packages/source/F/Fabric/Fabric-1.10.0.tar.gz"
  sha256 "edb2702b4655600f0a49a97e654c79f5b21490ce30f77d1313dd851f0b60335a"

  depends_on :python
  depends_on :paramiko
  depends_on :ecdsa

  def install
    ENV["PYTHONPATH"] = lib+"python2.7/site-packages"
    ENV.prepend_create_path 'PYTHONPATH', libexec+'lib/python2.7/site-packages'
    system "python", "setup.py", "install", "--single-version-externally-managed", "--record=installed.txt",
           "--prefix=#{prefix}"
    #system "python", "setup.py", "install", "--prefix=#{prefix}"
    bin.env_script_all_files(libexec+'bin', :PYTHONPATH => ENV['PYTHONPATH'])
  end

  test do
    system "#{bin}/fab", "--help"
  end
end
