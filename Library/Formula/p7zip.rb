require 'formula'

class P7zip < Formula
  homepage 'http://p7zip.sourceforge.net/'
  url 'https://downloads.sourceforge.net/project/p7zip/p7zip/9.20.1/p7zip_9.20.1_src_all.tar.bz2'
  sha1 '1cd567e043ee054bf08244ce15f32cb3258306b7'

  bottle do
    sha1 "c734e7052a1e3e9e280b189db31cf59e9d4f98e6" => :yosemite
    sha1 "aba193d047e84781a4d18911a41e77c16d520aea" => :mavericks
    sha1 "0d6f280dcedc67a789bbfd54f0ddef65899f4dfe" => :mountain_lion
  end

  option '32-bit'

  def install
    if Hardware.is_32_bit? or build.build_32_bit?
      mv 'makefile.macosx_32bits', 'makefile.machine'
    else
      mv 'makefile.macosx_64bits', 'makefile.machine'
    end

    system "make", "all3",
                   "CC=#{ENV.cc} $(ALLFLAGS)",
                   "CXX=#{ENV.cxx} $(ALLFLAGS)"
    system "make", "DEST_HOME=#{prefix}",
                   "DEST_MAN=#{man}",
                   "install"

    # install.sh chmods to 444, which is bad and breaks uninstalling
    system "chmod -R +w #{doc}"
  end
end
