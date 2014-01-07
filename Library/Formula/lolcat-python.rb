require 'formula'

class LolcatPython < Formula
  homepage 'https://github.com/tehmaze/lolcat'
  url 'https://github.com/tehmaze/lolcat/archive/8f5fc62550.tar.gz'
  sha1 '0f608e1deaebb214df557ced299e664e68e03874'
  version '0.1'
  head 'https://github.com/tehmaze/lolcat.git'

  conflicts_with 'lolcat-ryby'

  depends_on :python

  def install
    system "python", "setup.py", "install", "--prefix=#{prefix}"
    bin.env_script_all_files(libexec+'bin', :PYTHONPATH => ENV['PYTHONPATH'])
  end
end
