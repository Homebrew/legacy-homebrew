require 'formula'

class GitTig < Formula
  homepage 'http://jonas.nitro.dk/tig/'
  url 'http://jonas.nitro.dk/tig/releases/tig-1.2.tar.gz'
  sha1 '38bff28a205b94623ad0c087a3073c986002dc83'

  depends_on 'ncurses'
  depends_on 'libiconv'
  depends_on 'asciidoc' 

  def install

    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "#{bin}/tig", "--version"
  end
end
