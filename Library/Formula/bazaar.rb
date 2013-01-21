require 'formula'

class Bazaar < Formula
  homepage 'http://bazaar-vcs.org/'
  url 'https://launchpad.net/bzr/2.5/2.5.1/+download/bzr-2.5.1.tar.gz'
  sha1 '7e2776e3aaf8fb48828026d3fc2a3047465eea5e'

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

end
