require 'formula'

class Jless < Formula
  DISTFILES = 'ftp://ftp.freebsd.org/pub/FreeBSD/ports/distfiles'
  url "#{DISTFILES}/less-382.tar.gz"
  sha1 '3c3f1ae0bf18039b047524ff0f573ef514bcc944'
  homepage 'http://www.greenwoodsoftware.com/less/'
  version '382+iso262+ext03'

  def patches
    [ "#{DISTFILES}/less-382-iso258.patch.gz",
      "#{DISTFILES}/less-382-iso258-259.patch.gz",
      "#{DISTFILES}/less-382-iso259-260.patch.gz",
      "#{DISTFILES}/less-382-iso260-261.patch.gz",
      "#{DISTFILES}/less-382-iso261-262.patch.gz",
    ]
  end

  def patch_ext
    # http://bogytech.blogspot.com/2011/07/kterm-jless-screen.html
    ext_url = 'https://docs.google.com/uc?id=0B0E5E7E1sD2nZTI4NmUzZDAtZTY1MC00YmI4LTkyNzQtYmRmYjJkNzJmNzgy'
    ext_name = 'less-382-iso262.ext03.patch'
    curl ext_url, '-L', '-o', ext_name+'.gz'
    safe_system "/usr/bin/gunzip", ext_name+'.gz'
    safe_system '/usr/bin/patch', '-f', '-i', ext_name
  end

  def install
    patch_ext
    system "./configure", "--prefix=#{prefix}", "--mandir=#{prefix}/share/man"
    system "make install"
  end

  def caveats
    "You may need to set the environment variable 'JLESSCHARSET' to japanese-utf8"
  end
end

