require 'formula'

class Guilt < Formula
  homepage 'http://packages.debian.org/wheezy/guilt'
  url 'http://ftp.de.debian.org/debian/pool/main/g/guilt/guilt_0.35.orig.tar.gz'
  sha1 'e722180bc100afc096a1bd5c8338f797268c9947'

  def install
    # Skip the documentation, it depends on xmlto.
    system "make", "PREFIX=#{prefix}", "install"
  end
end
