require 'formula'

class Bash < Formula
  homepage 'http://www.gnu.org/software/bash/'
  url 'http://ftpmirror.gnu.org/bash/bash-4.2.tar.gz'
  mirror 'http://ftp.gnu.org/gnu/bash/bash-4.2.tar.gz'
  sha256 'a27a1179ec9c0830c65c6aa5d7dab60f7ce1a2a608618570f96bfa72e95ab3d8'
  version '4.2.45'

  depends_on 'readline'

  # Vendor the patches. The mirrors are unreliable for getting the patches,
  # and the more patches there are, the more unreliable they get. Upstream
  # patches can be found in: http://ftpmirror.gnu.org/bash/bash-4.2-patches
  def patches
    { :p0 => "https://gist.github.com/jacknagel/4008180/raw/1509a257060aa94e5349250306cce9eb884c837d/bash-4.2-001-045.patch" }
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
