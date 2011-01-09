require 'formula'

class LibgpgError32 <Formula
  @url='ftp://ftp.gnupg.org/gcrypt/libgpg-error/libgpg-error-1.10.tar.bz2'
  @homepage='http://www.gnupg.org/'
  @sha1='95b324359627fbcb762487ab6091afbe59823b29'

  def keg_only? ; <<-EOS
We don't want this conflicting as it is only here for wine... so keg_only it
    EOS
  end

  def install
    ENV.j1
    
    build32 = "-arch i386 -m32"
    ENV.append "CFLAGS", build32
    ENV.append "CXXFLAGS", "-D_DARWIN_NO_64_BIT_INODE"
    ENV.append "LDFLAGS", build32
    
    system "./configure", "--prefix=#{prefix}", "--disable-debug", "--disable-dependency-tracking"
    system "make install"
  end
end
