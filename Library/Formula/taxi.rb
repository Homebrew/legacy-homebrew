require "formula"
require "fileutils"

class Taxi < Formula
  homepage "https://github.com/sephii/taxi"
  url "https://github.com/sephii/taxi/archive/v3.1.0.tar.gz"
  sha1 "d8f3a1a5a39e16e8778324815be6dfe4af46a266"

  depends_on :python if MacOS.version <= :snow_leopard

  resource "colorama" do
    url "https://pypi.python.org/packages/source/c/colorama/colorama-0.3.2.zip"
    sha1 "90195c5f004225900b0f386de6bfc0e8aafbc75f"
  end

  def install
    ENV.prepend_create_path "PYTHONPATH", libexec+"lib/python2.7/site-packages"
    ENV.prepend_create_path "PYTHONPATH", prefix+"lib/python2.7/site-packages"

    resource("colorama").stage { system "python", "setup.py", "install", "--prefix=#{libexec}" }

    system "python", "setup.py", "install", "--prefix=#{prefix}", "--single-version-externally-managed", "--record=installed.txt"

    man1.install Dir['doc/*']

    bin.env_script_all_files(libexec+"bin", :PYTHONPATH => ENV["PYTHONPATH"])
  end

  test do
    config_filename = "/tmp/.tksrc"

    FileUtils.cp("#{prefix}/share/man/man1/tksrc.sample", config_filename)
    system "#{bin}/taxi", "stat", "--config=#{config_filename}"
  end
end
