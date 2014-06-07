require 'formula'

class Dex2jar < Formula
  homepage 'https://code.google.com/p/dex2jar/'
  url 'https://dex2jar.googlecode.com/files/dex2jar-0.0.9.15.zip'
  sha1 'cc9366836d576ce22a18de8f214368636db9fcba'

  def install
    # Remove Windows scripts
    rm_rf Dir['*.bat']

    # Install files
    prefix.install_metafiles
    libexec.install Dir['*']

    Dir.glob("#{libexec}/*.sh") do |script|
      bin.install_symlink script => File.basename(script, '.sh')
    end
  end
end
