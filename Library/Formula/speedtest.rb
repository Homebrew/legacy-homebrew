require "formula"

class Speedtest < Formula
  homepage "https://github.com/sivel/speedtest-cli"
  url "https://github.com/sivel/speedtest-cli/archive/v0.2.7.tar.gz"
  head "https://github.com/sivel/speedtest-cli.git"
  sha1 "d4e48594aa9eb4ab5c00a93584c02af0371d3f79"

  depends_on :python

  def install
    system "python", "setup.py", "install",
                     "--prefix=#{prefix}",
                     "--single-version-externally-managed",
                     "--record=installed.txt"

    bin.env_script_all_files(libexec+"bin", :PYTHONPATH => ENV["PYTHONPATH"])
    File.delete prefix+"bin/speedtest"
    man1.install "speedtest-cli.1"
  end
end
