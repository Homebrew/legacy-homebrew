require 'formula'

class P7zip < Formula
  homepage 'http://p7zip.sourceforge.net/'
  url 'https://downloads.sourceforge.net/project/p7zip/p7zip/9.20.1/p7zip_9.20.1_src_all.tar.bz2'
  sha1 '1cd567e043ee054bf08244ce15f32cb3258306b7'

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
