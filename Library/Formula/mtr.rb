require 'formula'

class Mtr < Formula
  url 'ftp://ftp.bitwizard.nl/mtr/mtr-0.80.tar.gz'
  homepage 'http://www.bitwizard.nl/mtr/'
  md5 'fa68528eaec1757f52bacf9fea8c68a9'

  depends_on 'gtk+' unless ARGV.include? "--no-gtk"

  def options
    [
      ['--no-gtk', "Don't build with Gtk+ support"]
    ]
  end

  def install
    # We need to add this because nameserver8_compat.h has been removed in Snow Leopard
    ENV['LIBS'] = "-lresolv"
    args = ["--prefix=#{prefix}", "--disable-debug", "--disable-dependency-tracking"]
    args << "--without-gtk" if ARGV.include? "--no-gtk"
    system "./configure", *args
    system "make install"
  end

  def caveats
    "Run mtr sudo'd in order to avoid the error: `unable to get raw sockets'"
  end
end
