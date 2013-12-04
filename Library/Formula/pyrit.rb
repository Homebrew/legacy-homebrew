require 'formula'

class Pyrit < Formula
  homepage 'https://code.google.com/p/pyrit/'
  url 'https://pyrit.googlecode.com/files/pyrit-0.4.0.tar.gz'
  sha1 '3041c0d593c21df88f41416be872eca0997cf22b'

  depends_on :python
  depends_on "libdnet"

  def install
    python do
      system python, "setup.py", "build"
      system python, "setup.py", "install"
    end
  end
  def caveats
    python.standard_caveats if python
  end
end
