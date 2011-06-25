require 'formula'

def use_libnet?
  not ARGV.include? '--disable-libnet'
end

def use_glib?
  not ARGV.include? '--disable-libglib'
end

class Libnids < Formula
  url 'http://downloads.sourceforge.net/project/libnids/libnids/1.24/libnids-1.24.tar.gz'
  homepage 'http://libnids.sourceforge.net/'
  md5 '72d37c79c85615ffe158aa524d649610'

  depends_on 'libnet' if use_libnet?
  depends_on 'glib' if use_glib?

  def options
    [
      ["--disable-libnet", "Don't include code requiring libnet"],
      ["--disable-libglib", "Don't use glib2 for multiprocessing support"]
    ]
  end

  def install
    args = ["--prefix=#{prefix}", "--mandir=#{man}"]
    args << "--disable-libnet" unless use_libnet?
    args << "--disable-libglib" unless use_glib?

    system "./configure", *args
    system "make install"
  end
end
