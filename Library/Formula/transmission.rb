require 'formula'

class Transmission < Formula
  homepage 'http://www.transmissionbt.com/'
  url 'http://download.transmissionbt.com/files/transmission-2.73.tar.bz2'
  sha1 '49f886ecb391c8901cd40f42b2f4a0df1ea4dcab'

  depends_on 'pkg-config' => :build # So it will find system libcurl
  depends_on 'libevent'
  depends_on 'intltool' => :optional
  depends_on 'gettext' => :optional # need gettext if intltool is used

  def install
    args = ["--disable-dependency-tracking",
            "--prefix=#{prefix}",
            "--disable-mac",
            "--without-gtk"]

    args << "--disable-nls" unless Formula.factory("intltool").installed? and
                                   Formula.factory("gettext").installed?

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
