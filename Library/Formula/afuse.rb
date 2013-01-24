require 'formula'

class Afuse < Formula
  homepage 'https://github.com/pcarrier/afuse/'
  url 'https://afuse.googlecode.com/files/afuse-0.4.tar.gz'
  sha1 '8587b9c590310a63519054c4a577388d15a3d7bb'

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
