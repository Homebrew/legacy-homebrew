require "formula"

class Doitlive < Formula
  homepage "http://doitlive.readthedocs.org/en/latest/"
  url "https://pypi.python.org/packages/source/d/doitlive/doitlive-2.2.0.tar.gz"
  sha1 "00d9f4fa2e25cc6ac14d6d9a1e14c9214c29ff48"

  bottle do
    cellar :any
    sha1 "15cee0e3795dc9fe364c21f38e2a79e0adf7fbd8" => :mavericks
    sha1 "fe98393027e48946b9e9e40fe0f8d5c2d4494ecf" => :mountain_lion
    sha1 "f8fb5e520dc2287095285d2ceb1fad5498db5a4a" => :lion
  end

  depends_on :python if MacOS.version <= :snow_leopard

  def install
    ENV.prepend_create_path "PYTHONPATH", libexec+"lib/python2.7/site-packages"
    system "python", "setup.py", "install", "--prefix=#{libexec}"

    bin.install Dir[libexec/"bin/*"]
    bin.env_script_all_files(libexec+"bin", :PYTHONPATH => ENV["PYTHONPATH"])
  end

  test do
    system "#{bin}/doitlive", "themes", "--preview"
  end
end
