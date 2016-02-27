# coding: utf-8
class Snakemake < Formula
  desc "Pythonic workflow system"
  homepage "http://snakemake.bitbucket.org"
  url "https://pypi.python.org/packages/source/s/snakemake/snakemake-3.5.5.tar.gz"
  sha256 "1f13667fd0dea7d2f35414399646288b8aece2cf9791566992001d95d123eb1b"

  depends_on :python3

  def install
    xy = Language::Python.major_minor_version "python3"
    ENV.prepend_create_path "PYTHONPATH", libexec/"lib/python#{xy}/site-packages"
    system "python3", *Language::Python.setup_install_args(libexec)

    bin.install Dir[libexec/"bin/*"]
    bin.env_script_all_files(libexec/"bin", :PYTHONPATH => ENV["PYTHONPATH"])
  end

  test do
    system "#{bin}/snakemake", "-v"
  end
end
