require 'formula'

class Avrdude <Formula
  url 'http://mirror.lihnidos.org/GNU/savannah/avrdude/avrdude-5.10.tar.gz'
  homepage 'http://savannah.nongnu.org/projects/avrdude/'
  md5 '69b082683047e054348088fd63bad2ff'
  depends_on "libftdi" if ARGV.include? "--ftdi"
  
  def options
    [["--ftdi", "FTDI BitBang support"]]
  end

  def patches
    "https://gist.github.com/raw/759134/4b51f93c6e6afbd6a50adca808c685385f86ff53/ftdi-bitbang-5.10-2.patch" if ARGV.include? "--ftdi"
  end

  def install
    ENV.j1
    if ARGV.include? "--ftdi"
      system "autoreconf"
      system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}", "--enable-ftdi-bitbang"
    else
      system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    end
    system "make install"
  end
end
