require "formula"

class Ino < Formula
  homepage "http://inotool.org"
  url "https://pypi.python.org/packages/source/i/ino/ino-0.3.6.tar.gz"
  sha1 "73fc512ce005d85d6aec5d910d68d6bf8c0f3b26"

  depends_on "picocom"
  depends_on :python if MacOS.version <= :snow_leopard

  def install
    ENV["PYTHONPATH"] = lib+"python2.7/site-packages"
    ENV.prepend_create_path "PYTHONPATH", lib+"python2.7/site-packages"

    system "python", "setup.py", "install", "--prefix=#{prefix}"

    bin.env_script_all_files(libexec+'bin', :PYTHONPATH => ENV['PYTHONPATH'])
  end

  test do
    system "#{bin}/ino", "--help"
  end
end
