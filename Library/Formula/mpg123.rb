require 'formula'

class Mpg123 < Formula
  url 'http://downloads.sourceforge.net/project/mpg123/mpg123/1.13.5/mpg123-1.13.5.tar.bz2'
  homepage 'http://www.mpg123.de/'
  sha1 '4dd627d36fce9d4be1268ac2ec4af04040af4385'

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

    if MacOS.prefer_64_bit?
      args << "--with-cpu=x86-64"
    else
      args << "--with-cpu=sse_alone"
    end

    system "./configure", *args

    ['.', 'src', 'src/output', 'src/libmpg123'].each do |path|
      inreplace "#{path}/Makefile" do |s|
        # why do we do this?
        s.change_make_var! "LDFLAGS", "-Wl,-read_only_relocs,suppress"
      end
    end

    system "make install"
  end
end
