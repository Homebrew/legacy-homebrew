require 'formula'

class Mpg123 < Formula
  homepage 'http://www.mpg123.de/'
  url 'http://downloads.sourceforge.net/project/mpg123/mpg123/1.13.7/mpg123-1.13.7.tar.bz2'
  sha1 '33b71c932b87004f3c8fed527b1f9a4b5f4337b2'

  # mpg123 can't find its plugins if there are no la files
  def skip_clean? path
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
