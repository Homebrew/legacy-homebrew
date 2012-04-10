require 'formula'

class Jless < Formula
  url 'http://ftp.de.debian.org/debian/pool/main/j/jless/jless_382-iso262.orig.tar.gz'
  sha1 '3c3f1ae0bf18039b047524ff0f573ef514bcc944'
  homepage 'http://www.greenwoodsoftware.com/less/'
  version '382+iso262+ext03'

  def patches
    iso_patches = ['less-382-iso258.dpatch',
                   'less-382-iso258-259.dpatch',
                   'less-382-iso259-260.dpatch',
                   'less-382-iso260-261.dpatch',
                   'less-382-iso261-262.dpatch'].collect {|p| "debian/patches/#{p}"}

    # http://bogytech.blogspot.com/2011/07/kterm-jless-screen.html
    ext_patch = 'less-382-iso262.ext03.patch'
    ext_url = 'https://docs.google.com/uc?id=0B0E5E7E1sD2nZTI4NmUzZDAtZTY1MC00YmI4LTkyNzQtYmRmYjJkNzJmNzgy'
    curl ext_url, '-L', '-o', ext_patch+'.gz'
    safe_system "/usr/bin/gunzip", ext_patch+'.gz'

    p = ['http://ftp.de.debian.org/debian/pool/main/j/jless/jless_382-iso262-2.diff.gz',
         *iso_patches]
    p << ext_patch
    p
  end

  def install
    system "./configure", "--prefix=#{prefix}", "--mandir=#{prefix}/share/man"
    system "make install binprefix=j manprefix=j"
  end

  def caveats
    "You may need to set the environment variable 'JLESSCHARSET' to japanese-utf8"
  end
end

