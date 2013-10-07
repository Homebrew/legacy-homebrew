require 'formula'

class Binwalk < Formula
  homepage 'http://code.google.com/p/binwalk/'
  url 'https://binwalk.googlecode.com/files/binwalk-1.2.1.tar.gz'
  sha1 '1c5830003ca8d4bcaa65c5ab31b858d46d4731fa'

  # Technically, matplotlib is optional, but the binwalk setup script hardcodes
  # a check that requires user raw_input to override
  depends_on :python => 'matplotlib'
  depends_on 'libmagic' => 'with-python'

  def install
    cd "src" do
      system python, "setup.py", "install", "--prefix=#{prefix}"
    end
  end
end
