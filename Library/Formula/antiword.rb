require 'formula'

class Antiword < Formula
  url 'http://www.winfield.demon.nl/linux/antiword-0.37.tar.gz'
  homepage 'http://www.winfield.demon.nl/'
  md5 'f868e2a269edcbc06bf77e89a55898d1'

  skip_clean 'share/antiword'

  def install
    inreplace "Makefile" do |s|
      s.change_make_var! "GLOBAL_INSTALL_DIR", bin
      s.change_make_var! "GLOBAL_RESOURCES_DIR", share+'antiword'
    end

    inreplace 'antiword.h', '/usr/share/antiword', share+'antiword'

    system "make CC=#{ENV.cc} LD=#{ENV.cc}"
    bin.install 'antiword'
    man1.install 'Docs/antiword.1'
    (share+'antiword').mkpath
  end

  def caveats; <<-EOS.undent
    You can install mapping files globally to:
      #{HOMEBREW_PREFIX}/share/antiword
    or locally to:
      ~/.antiword
    EOS
  end
end
