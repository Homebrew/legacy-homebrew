require 'formula'

class Pulseaudio < Formula
  url 'http://freedesktop.org/software/pulseaudio/releases/pulseaudio-2.1.tar.gz'
  homepage 'http://pulseaudio.org'
  md5 '86912af7fd4f8aa67f83182c135b2a5c'

  head 'git://anongit.freedesktop.org/pulseaudio/pulseaudio'

  option "with-dbus", "Enable dbus"
  
  # Dependencies from http://www.freedesktop.org/wiki/Software/PulseAudio/Ports/OSX
  depends_on 'autoconf' if build.head?
  depends_on 'automake' if build.head?
  depends_on 'intltool' 
  depends_on 'libtool' if build.head? and Formula.factory('libtool').installed?
  depends_on 'libsndfile'
  depends_on 'speex'
  depends_on 'gdbm'
  depends_on 'liboil'
  depends_on 'json-c'
  depends_on 'dbus' if build.include? 'with-dbus'

  def install
    args = ["--disable-jack",
            "--disable-hal",
            "--disable-bluez",
            "--disable-avahi",
            "--prefix=#{prefix}",
            "--with-udev-rules-dir=#{prefix}/lib/udev/rules.d",
            "--with-mac-sysroot=" + MacOS.sdk_path,
            "--with-mac-version-min=" + MacOS.version]

    args << '--disable-dbus' unless build.include? 'with-dbus'
    args << "--disable-nls" if build.head? and not Formula.factory('libtool').installed?

    if ARGV.build_head? then
      system "./autogen.sh", *args
    else
      system "./configure", *args
    end
    
    system "make"
    system "make install"
  end

  def test
    system "pulseaudio"
  end
end