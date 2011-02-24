require 'formula'

class Fish <Formula
  url 'http://downloads.sourceforge.net/project/fish/fish/1.23.1/fish-1.23.1.tar.bz2'
  homepage 'http://fishshell.org/'
  md5 'ead6b7c6cdb21f35a3d4aa1d5fa596f1'

  depends_on 'readline'
  skip_clean 'share/doc'

  def install
    inreplace ["proc.c"] do |s|
      s.gsub!("tv\.tv_sec=5","tv.tv_sec=0")
      s.gsub!("tv\.tv_usec=0","tv.tv_usec=10000")
    end
    system "./configure", "--prefix=#{prefix}", "--without-xsel"
    system "make install"
  end

  def caveats
    "You will need to add #{HOMEBREW_PREFIX}/bin/fish to /etc/shells\n"+
    "Run `chsh -s #{HOMEBREW_PREFIX}/bin/fish' to make fish your default shell."
  end
end
