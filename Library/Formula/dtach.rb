require 'formula'

class Dtach <Formula
  url 'http://downloads.sourceforge.net/project/dtach/dtach/0.8/dtach-0.8.tar.gz'
  md5 'ec5999f3b6bb67da19754fcb2e5221f3'
  homepage 'http://dtach.sourceforge.net/'

  def install
    system "./configure", "--prefix=#{prefix}", "--disable-debug", "--disable-dependency-tracking"
    
    # Includes <config.h> instead of "config.h", so "." needs to be in the include path.
    ENV.append "CFLAGS", "-I."
    
    inreplace "Makefile" do |f|
      # Use our own flags, thanks.
      %w[CC CFLAGS LIBS].each { |flag| f.change_make_var! flag, "" }
    end
    
    system "make"
    bin.install "dtach"
  end
end
