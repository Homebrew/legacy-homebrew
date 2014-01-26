require 'formula'

class Mackup < Formula
  homepage 'https://github.com/lra/mackup'
  # url 'https://github.com/lra/mackup/archive/0.5.8.tar.gz'
  # TOREMOVE
  url 'https://github.com/lra/mackup/archive/app_structure.zip'
  version '0.5.9'
  # TOREMOVE
  # sha1 'adab98fe9350ce45d4502a44b891dde64375d604'
  sha1 'bda5b18e8b4a247810bc67611c45ca0f3b505272'
  head 'https://github.com/lra/mackup.git'
  depends_on :python

  def install
    # bin.install "mackup.py" => "mackup"
    system 'python', 'setup.py', 'install', "--prefix=#{prefix}"
    # (share/'mackup').install '.mackup.cfg' => 'mackup.cfg.example'
  end

  def test
    system "#{bin}/mackup", '-h'
  end
end
