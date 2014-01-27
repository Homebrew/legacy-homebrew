require 'formula'

class Mackup < Formula
  homepage 'https://github.com/lra/mackup'
  url 'https://github.com/lra/mackup/archive/0.5.9.tar.gz'
  sha1 '69d13c27b3a2794ddecb415333e783ca45aff055'

  head 'https://github.com/lra/mackup.git'

  depends_on :python

  def install
    bin.install 'bin/mackup'
    (prefix + 'mackup').install 'mackup/__init__.py', 'mackup/main.py'
    (share).install '.mackup.cfg' => 'mackup.cfg.example'
  end

  def test
    system "#{bin}/mackup", '-h'
  end
end
