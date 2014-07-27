require "formula"

class Doitlive < Formula
  homepage "http://doitlive.readthedocs.org/en/latest/"
  url "https://pypi.python.org/packages/source/d/doitlive/doitlive-2.2.0.tar.gz"
  sha1 "00d9f4fa2e25cc6ac14d6d9a1e14c9214c29ff48"

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
