require 'formula'

class Afuse < Formula
  homepage 'https://github.com/pcarrier/afuse/'
  url 'https://afuse.googlecode.com/files/afuse-0.4.1.tar.gz'
  sha1 '156b196a27c181eee8b192e7922fbe3c32c858e3'

  depends_on :automake
  depends_on :libtool

  depends_on 'pkg-config' => :build
  depends_on 'fuse4x'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end

  def caveats; <<-EOS.undent
    Make sure to follow the directions given by `brew info fuse4x-kext`
    before trying to use a FUSE-based filesystem.
    EOS
  end
end
