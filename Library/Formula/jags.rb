require 'formula'

class Jags < Formula
  url 'http://sourceforge.net/projects/mcmc-jags/files/JAGS/2.x/Source/JAGS-2.2.0.tar.gz'
  homepage 'http://www-fis.iarc.fr/~martyn/software/jags/'
  md5 '83dc69ad06e963dfa29b2faf5b091e63'

  def install
    ENV.fortran

    arch = MacOS.prefer_64_bit? ?  '-arch x86_64' : '-arch i386'
    compile_flags = "-mmacosx-version-min=10.5 -isysroot #{MacOS.xcode_prefix}/SDKs/MacOSX10.5.sdk #{arch}"
    ENV['CFLAGS'] = compile_flags
    ENV['CXXFLAGS'] = compile_flags
    ENV['FFLAGS'] = compile_flags
    ENV['LDFLAGS'] = compile_flags

    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make"
    system "make install"
  end
end
