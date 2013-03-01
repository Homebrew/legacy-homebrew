require 'formula'

class Transmission < Formula
  homepage 'http://www.transmissionbt.com/'
  url 'http://download.transmissionbt.com/files/transmission-2.77.tar.bz2'
  sha1 'a26298dc814b3995a7e4a7f6566fc16b1463bbbb'

  option 'with-nls', 'Build with native language support'

  depends_on 'pkg-config' => :build # So it will find system libcurl
  depends_on 'libevent'

  if build.with? 'nls'
    depends_on 'intltool' => :build
    depends_on 'gettext'
  end

  def install
    args = %W[--disable-dependency-tracking
              --prefix=#{prefix}
              --disable-mac
              --without-gtk]

    args << "--disable-nls" unless build.with? 'nls'

    system "./configure", *args
    system "make" # Make and install in one step fails
    system "make install"
  end

  def caveats; <<-EOS.undent
    This formula only installs the command line utilities.
    Transmission.app can be downloaded from Transmission's website:
      http://www.transmissionbt.com
    EOS
  end
end
