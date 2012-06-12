require 'formula'

class Bash < Formula
  homepage 'http://www.gnu.org/software/bash/'
  url 'http://ftpmirror.gnu.org/bash/bash-4.2.tar.gz'
  mirror 'http://ftp.gnu.org/gnu/bash/bash-4.2.tar.gz'
  sha256 'a27a1179ec9c0830c65c6aa5d7dab60f7ce1a2a608618570f96bfa72e95ab3d8'
  version '4.2.29'

  depends_on 'readline'

  def patches
    patch_level = version.split('.').last.to_i
    {'p0' => (1..patch_level).map { |i| "http://ftpmirror.gnu.org/bash/bash-4.2-patches/bash42-%03d" % i }}
  end

  def install
    system "./configure", "--prefix=#{prefix}", "--with-installed-readline"
    system "make install"
  end

  def caveats; <<-EOS.undent
    In order to use this build of bash as your login shell,
    it must be added to /etc/shells.
    EOS
  end
end
