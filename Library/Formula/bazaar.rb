require 'formula'

class Bazaar < Formula
  homepage 'http://bazaar-vcs.org/'
  url 'https://launchpad.net/bzr/2.6/2.6.0/+download/bzr-2.6.0.tar.gz'
  sha1 '5eb4d0367c6d83396250165da5bb2c8a9f378293'

  depends_on :python

  def install
    # Make and install man page first
    system "make man1/bzr.1"
    man1.install "man1/bzr.1"

    python do
      # In this python block, the site-packages are already set up
      system python, "setup.py", "install", "--prefix=#{prefix}"
      (prefix/'man').rmtree
    end
  end

  def caveats
    python.standard_caveats if python
  end
end
