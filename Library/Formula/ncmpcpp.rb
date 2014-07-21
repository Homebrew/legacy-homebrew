require 'formula'

class Ncmpcpp < Formula
  homepage 'http://ncmpcpp.rybczak.net/'
  url 'http://ncmpcpp.rybczak.net/stable/ncmpcpp-0.5.10.tar.bz2'
  sha1 '5e34733e7fbaf2862f04fdf8af8195ce860a9014'

  head do
    url 'git://repo.or.cz/ncmpcpp.git'

    depends_on :autoconf
    depends_on :automake
    depends_on :libtool
    depends_on 'boost' # not needed by stable
    depends_on 'readline'
  end

  depends_on 'pkg-config' => :build
  depends_on 'taglib'
  depends_on 'libmpdclient'
  depends_on 'fftw' if build.include? "visualizer"

  fails_with :clang do
    cause "'itsTempString' is a private member of 'NCurses::basic_buffer<char>'"
  end if build.stable?

  option 'outputs', 'Compile with mpd outputs control'
  option 'visualizer', 'Compile with built-in visualizer'
  option 'clock', 'Compile with optional clock tab'

  def install
    ENV.append 'LDFLAGS', '-liconv'
    args = ["--disable-dependency-tracking",
            "--prefix=#{prefix}",
            "--with-taglib",
            "--with-curl",
            "--enable-unicode"]
    args << '--enable-outputs' if build.include? 'outputs'
    args << '--enable-visualizer' if build.include? 'visualizer'
    args << '--enable-clock' if build.include? 'clock'

    if build.head?
      # Also runs configure
      system "./autogen.sh", *args
    else
      system "./configure", *args
    end
    system "make install"
  end
end
