require 'formula'

class Jags <Formula
  url 'http://sourceforge.net/projects/mcmc-jags/files/JAGS/2.x/Source/JAGS-2.2.0.tar.gz'
  homepage 'http://www-fis.iarc.fr/~martyn/software/jags/'
  md5 '83dc69ad06e963dfa29b2faf5b091e63'
  version '2.2'

  def install
    
    args = ["--prefix=#{prefix}",
            "--disable-debug",
            "--disable-dependency-tracking"]

    if snow_leopard_64?
      arch = '-arch x86_64'
    else
      arch = '-arch i386'
    end
    
    ENV['CFLAGS']="-mmacosx-version-min=10.5 -isysroot /Developer/SDKs/MacOSX10.5.sdk #{arch}"
    ENV['CXXFLAGS']="-mmacosx-version-min=10.5 -isysroot /Developer/SDKs/MacOSX10.5.sdk #{arch}"
    ENV['FFLAGS']="-mmacosx-version-min=10.5 -isysroot /Developer/SDKs/MacOSX10.5.sdk #{arch}"
    ENV['LDFLAGS']="-mmacosx-version-min=10.5 -isysroot /Developer/SDKs/MacOSX10.5.sdk #{arch}"

    system "./configure", *args
    system "make"
    system "make install"
  end
end
