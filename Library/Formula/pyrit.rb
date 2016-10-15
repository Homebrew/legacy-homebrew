require 'formula'

class ScapyRequirement < Requirement
  build true
  fatal true

  satisfy { which 'scapy' }

  def message
    <<-EOS.undent
      To use this formula you need to install scapy.
      brew install samueljohn/python/scapy
    EOS
  end
end

class Pyrit < Formula
  homepage 'https://code.google.com/p/pyrit/'
  url 'https://pyrit.googlecode.com/files/pyrit-0.4.0.tar.gz'
  sha1 '3041c0d593c21df88f41416be872eca0997cf22b'

  depends_on :python
  depends_on 'libdnet' => 'with-python'
  depends_on ScapyRequirement

  def install
    python do
      system python, "setup.py", "build"
      system python, "setup.py", "install", "--prefix=#{prefix}"
    end
  end

  def caveats
    python.standard_caveats if python
  end
end
