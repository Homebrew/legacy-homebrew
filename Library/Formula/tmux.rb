require 'formula'

class Tmux <Formula
  url 'http://downloads.sourceforge.net/tmux/tmux-1.1.tar.gz'
  md5 'faf2fc52ac3ae63d899f6fece2c112cd'
  homepage 'http://tmux.sourceforge.net'

  def install
    ENV['PREFIX'] = "#{prefix}"
    system "./configure"

    inreplace "GNUmakefile" do |f|
      # Fix 'install' flags
      f.gsub! " -g bin -o root", ""
      # Put docs in the right place
      f.gsub! "man/man1", "share/man/man1"
    end

    system "make install"
  end
end
