require 'formula'

class Jags <Formula
  url 'http://sourceforge.net/projects/mcmc-jags/files/JAGS/2.x/Source/JAGS-2.1.0.tar.gz/download'
  homepage 'http://www-fis.iarc.fr/~martyn/software/jags/'
  md5 'ddb5eb745cb48537517aba186d7030c8'
  version '2.1'
  

  def install
    # FIXME hard coded to x86_64 arch. The build only works with the arch is specified, but I don't know
    # how to get that param from the build environment. In Bash it's $HOSTTYPE but that's not in ENV[].
    ENV['CFLAGS']="-mmacosx-version-min=10.5 -isysroot /Developer/SDKs/MacOSX10.5.sdk -arch x86_64"
    ENV['CXXFLAGS']="-mmacosx-version-min=10.5 -isysroot /Developer/SDKs/MacOSX10.5.sdk -arch x86_64"
    ENV['FFLAGS']="-mmacosx-version-min=10.5 -isysroot /Developer/SDKs/MacOSX10.5.sdk -arch x86_64"
    ENV['LDFLAGS']="-mmacosx-version-min=10.5 -isysroot /Developer/SDKs/MacOSX10.5.sdk -arch x86_64"
    
    system "./configure", "--disable-debug", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make install"
  end
end
