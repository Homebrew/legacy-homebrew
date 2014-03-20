require 'formula'

class Pssh < Formula
  homepage 'https://code.google.com/p/parallel-ssh/'
  url 'https://parallel-ssh.googlecode.com/files/pssh-2.3.1.tar.gz'
  sha1 '65736354baaa289cffdf374eb2ffd9aa1eda7d85'

  depends_on :python

  def install
    system "python", "setup.py", "install",
      "--prefix=#{prefix}", "--install-data=#{share}"

    bin.env_script_all_files(libexec+'bin', :PYTHONPATH => ENV['PYTHONPATH'])
  end

  test do
    system "#{bin}/pssh", "--version"
  end
end
