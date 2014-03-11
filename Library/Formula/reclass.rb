require "formula"

class Reclass < Formula
  homepage "http://reclass.pantsfullofunix.net/"
  url "http://ftp.nl.debian.org/debian/pool/main/r/reclass/reclass_1.2.2.orig.tar.gz"
  sha1 "18baca3e853cdcfac441939a8db85478c3c7a87e"

  head 'https://github.com/madduck/reclass.git'

  depends_on :python

  def install
    ENV.prepend_create_path 'PYTHONPATH', "#{libexec}/lib/python2.7/site-packages"

    system "python", "setup.py", "install", "--prefix=#{libexec}"
    bin.install Dir[libexec/'bin/*']
    bin.env_script_all_files(libexec+'bin', :PYTHONPATH => ENV['PYTHONPATH'])
  end

  test do
    system "#{bin}/reclass", "--version"
  end
end
