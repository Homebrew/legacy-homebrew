require 'formula'

class Librsync < Formula
  homepage 'http://librsync.sourceforge.net/'
  url 'https://downloads.sourceforge.net/project/librsync/librsync/0.9.7/librsync-0.9.7.tar.gz'
  sha1 'd575eb5cae7a815798220c3afeff5649d3e8b4ab'

  bottle do
    cellar :any
    sha1 "8353f1b073ccf899a1f1d0e14eac81426efb1443" => :mavericks
    sha1 "078bf45d5ba1f809bfd024db62354330e063f3ff" => :mountain_lion
    sha1 "cb35ddba05801748025b1394bd89c359f0c4f934" => :lion
  end

  option :universal

  depends_on 'popt'

  def install
    ENV.universal_binary if build.universal?

    ENV.append 'CFLAGS', '-std=gnu89'

    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--mandir=#{man}",
                          "--enable-shared"

    inreplace 'libtool' do |s|
      s.gsub! /compiler_flags=$/, "compiler_flags=' #{ENV.cflags}'"
      s.gsub! /linker_flags=$/, "linker_flags=' #{ENV.ldflags}'"
    end

    system "make install"
  end
end
