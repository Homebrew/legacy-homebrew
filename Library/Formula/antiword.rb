require 'formula'

class Antiword < Formula
  homepage 'http://www.winfield.demon.nl/'
  url 'http://www.winfield.demon.nl/linux/antiword-0.37.tar.gz'
  sha1 '4364f7f99cb2d37f7d1d5bc14a335ccc0c67292e'

  skip_clean 'share/antiword'

  def install
    (share+'antiword').mkpath
    inreplace 'antiword.h', '/usr/share/antiword', share+'antiword'

    system "make", "CC=#{ENV.cc}",
                   "LD=#{ENV.cc}",
                   "CFLAGS=#{ENV.cflags} -DNDEBUG",
                   "GLOBAL_INSTALL_DIR=#{bin}",
                   "GLOBAL_RESOURCES_DIR=#{share}/antiword"
    bin.install 'antiword'
    man1.install 'Docs/antiword.1'
  end

  def caveats; <<-EOS.undent
    You can install mapping files globally to:
      #{HOMEBREW_PREFIX}/share/antiword
    or locally to:
      ~/.antiword
    EOS
  end
end
