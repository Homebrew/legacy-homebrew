require 'formula'

class Dex2jar < Formula
  homepage 'https://code.google.com/p/dex2jar/'
  url 'https://dex2jar.googlecode.com/files/dex2jar-0.0.9.13.zip'
  sha1 '89057a41d646b15a1a9bb38747371b35d32b326b'

  def install
    # Remove Windows scripts
    rm_rf Dir['*.bat']

    # Install files
    prefix.install_metafiles
    libexec.install Dir['*']

    Dir["#{libexec}/*.sh"].each do |script|
      bin.install_symlink script => File.basename(script, '.sh')
    end
  end
end
