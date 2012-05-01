require 'formula'

class Antiword < Formula
  homepage 'http://www.winfield.demon.nl/'
  url 'http://www.winfield.demon.nl/linux/antiword-0.37.tar.gz'
  md5 'f868e2a269edcbc06bf77e89a55898d1'

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
