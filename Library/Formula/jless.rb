require 'formula'

# jless (Jam Less) is Japan-ized Less.
# jless supports ISO 2022 code extension techniques and Japanese codes.

class Jless < Formula
  homepage 'http://www.greenwoodsoftware.com/less/'
  url 'http://ftp.de.debian.org/debian/pool/main/j/jless/jless_382-iso262.orig.tar.gz'
  version '382+iso262+ext03'
  sha1 '3c3f1ae0bf18039b047524ff0f573ef514bcc944'

  def patches
    # These will emerge from the debian patch zip
    iso_patches = ['less-382-iso258.dpatch',
                   'less-382-iso258-259.dpatch',
                   'less-382-iso259-260.dpatch',
                   'less-382-iso260-261.dpatch',
                   'less-382-iso261-262.dpatch'].collect {|p| "debian/patches/#{p}"}

    p = [
      # Debian patches
      'http://ftp.de.debian.org/debian/pool/main/j/jless/jless_382-iso262-2.diff.gz',
      *iso_patches
    ]

    # See: http://bogytech.blogspot.com/2011/07/kterm-jless-screen.html
    # Must come after the Debian patches
    p << 'https://docs.google.com/uc?id=0B0E5E7E1sD2nZTI4NmUzZDAtZTY1MC00YmI4LTkyNzQtYmRmYjJkNzJmNzgy'
    return p
  end

  def install
    system "./configure", "--prefix=#{prefix}", "--mandir=#{prefix}/share/man"
    system "make install binprefix=j manprefix=j"
  end

  def caveats
    "You may need to set the environment variable 'JLESSCHARSET' to japanese-utf8"
  end
end
