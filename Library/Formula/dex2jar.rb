require 'formula'

class Dex2jar < Formula
  homepage 'https://code.google.com/p/dex2jar/'
  url 'https://dex2jar.googlecode.com/files/dex2jar-0.0.9.13.zip'
  sha1 '89057a41d646b15a1a9bb38747371b35d32b326b'

  SCRIPTS = ['d2j-apk-sign.sh', 'd2j-asm-verify.sh', 'd2j-decrpyt-string.sh', 'd2j-dex-asmifier.sh', 'd2j-dex-dump.sh', 'd2j-dex2jar.sh', 'd2j-init-deobf.sh', 'd2j-jar-access.sh', 'd2j-jar-remap.sh', 'd2j-jar2dex.sh', 'd2j-jar2jasmin.sh', 'd2j-jasmin2jar.sh', 'dex-dump.sh', 'dex2jar.sh']

  def install
    # Remove Windows scripts
    rm_rf Dir['*.bat']

    # Install files
    prefix.install %w{ NOTICE.txt LICENSE.txt }
    libexec.install Dir['*']

    SCRIPTS.each do |script|
      bin.install_symlink "#{libexec}/#{script}" => "#{script.gsub('.sh', '')}"
    end
  end

  test do
    SCRIPTS.each do |script|
      system script
    end
  end
end
