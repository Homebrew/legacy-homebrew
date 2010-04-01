require 'formula'

class Mpg123 <Formula
  url 'http://downloads.sourceforge.net/project/mpg123/mpg123/1.9.2/mpg123-1.9.2.tar.bz2'
  homepage 'http://www.mpg123.de/'
  md5 '5313b1bcc0274b4d7c394397c205bb20'

  def skip_clean? path
    # mpg123 can't find its plugins if there are no la files
    path.extname == '.la'
  end

  def install
    args = ["--disable-debug", "--disable-dependency-tracking",
            "--with-optimization=4",
            "--prefix=#{prefix}",
            "--with-audio=coreaudio",
            "--with-default-audio=coreaudio"]

    if Hardware.is_64_bit?
      # adamv got compile failure for these conditions
      args << "--with-cpu=x86-64" unless MACOS_VERSION == 10.5 and Hardware.intel_family == :nehalem
    else
      # there are no Intel Mac computers without SSE
      args << "--with-cpu=sse_alone"
    end

    system "./configure", *args
    
    # ./configure incorrectly detects 10.5 as 10.4. Cut that crap out.
    ['.', 'src', 'src/output', 'src/libmpg123'].each do |path|
      inreplace "#{path}/Makefile" do |s|
        s.gsub! "-mmacosx-version-min=10.4 -isysroot /Developer/SDKs/MacOSX10.4u.sdk", ""
        s.change_make_var! "LDFLAGS", "-Wl,-read_only_relocs,suppress"
      end
    end
    
    system "make install"
  end
end
