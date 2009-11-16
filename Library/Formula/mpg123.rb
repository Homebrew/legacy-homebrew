require 'formula'

class Mpg123 <Formula
  url 'http://downloads.sourceforge.net/project/mpg123/mpg123/1.9.1/mpg123-1.9.1.tar.bz2'
  homepage 'http://www.mpg123.de/'
  md5 '39aa4407b53fa8c86f7d963bfe0702c9'

  def skip_clean? path
    # mpg123 can't find its plugins if there are no la files
    path.extname == '.la'
  end

  def install
    args = ["--disable-debug", "--disable-dependency-tracking",
            "--with-optimization=4",
            "--with-cpu=sse_alone",
            "--prefix=#{prefix}",
            "--with-audio=coreaudio",
            "--with-default-audio=coreaudio"]

    # This option causes compilation failure on 10.5 nehalem MacPro.
    # args << "--with-cpu=x86-64" if Hardware.is_64_bit?

    system "./configure", *args
    
    # ./configure incorrectly detects 10.5 as 10.4
    # Cut that crap out.
    
    ['', 'src/', 'src/output/', 'src/libmpg123/'].each do |path|
      inreplace "#{path}Makefile", # CFLAGS
        "-mmacosx-version-min=10.4 -isysroot /Developer/SDKs/MacOSX10.4u.sdk", ""

      inreplace "#{path}Makefile", # LDFLAGS
        "LDFLAGS =  -Wl,-syslibroot,/Developer/SDKs/MacOSX10.4u.sdk -Wl,-classic_linker -Wl,-read_only_relocs,suppress", 
        "LDFLAGS =  -Wl,-read_only_relocs,suppress"
    end
    
    system "make install"
  end
end
