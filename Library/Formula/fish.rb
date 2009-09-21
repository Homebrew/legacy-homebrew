require 'brewkit'

class Fish <Formula
  @url='http://fishshell.org/files/1.23.1/fish-1.23.1.tar.gz'
  @homepage='http:://fishshell.org/'
  @md5='4b2436843e63bebba467cc4add11428a'

  depends_on 'readline'

  def install
    system "./configure", "--prefix=#{prefix}", "--without-xsel"
    system "make install"
  end

  def caveats
    "You will need to add #{HOMEBREW_PREFIX}/bin/fish to /etc/shells\n"+
    "Run `chsh -s #{HOMEBREW_PREFIX}/bin/fish' to make fish your default shell."
  end
end
