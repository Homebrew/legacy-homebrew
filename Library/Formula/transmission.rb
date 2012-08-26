require 'formula'

class Transmission < Formula
  homepage 'http://www.transmissionbt.com/'
<<<<<<< HEAD
<<<<<<< HEAD
  url 'http://download.transmissionbt.com/files/transmission-2.60.tar.bz2'
  sha1 '1dfc64ff56f954d37b3cca4aa067f067e0fa9744'
=======
  url 'http://download.transmissionbt.com/files/transmission-2.61.tar.bz2'
  sha1 '7df170ecee6e62766859dca6ae0cf4e89c1ea99f'
>>>>>>> 1cd31e942565affb535d538f85d0c2f7bc613b5a
=======
  url 'http://download.transmissionbt.com/files/transmission-2.61.tar.bz2'
  sha1 '7df170ecee6e62766859dca6ae0cf4e89c1ea99f'
>>>>>>> 0dba76a6beda38e9e5357faaf3339408dcea0879

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
