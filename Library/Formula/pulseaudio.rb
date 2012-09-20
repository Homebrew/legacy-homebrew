require 'formula'

class Pulseaudio < Formula
  url 'http://freedesktop.org/software/pulseaudio/releases/pulseaudio-2.1.tar.gz'
  head 'git://anongit.freedesktop.org/pulseaudio/pulseaudio'
  homepage 'http://pulseaudio.org'
  md5 '86912af7fd4f8aa67f83182c135b2a5c'
  
  # Dependencies from http://www.freedesktop.org/wiki/Software/PulseAudio/Ports/OSX
  depends_on 'autoconf'
  depends_on 'automake'
  depends_on 'intltool'
  depends_on 'libtool'
  depends_on 'libsndfile'
  depends_on 'speex'
  depends_on 'gdbm'
  depends_on 'liboil'
  depends_on 'json-c'


  def install
    args = ["--disable-jack",
            "--disable-hal",
            "--disable-bluez",
            "--disable-dbus",
            "--disable-avahi",
            "--prefix=#{prefix}",
            "--with-udev-rules-dir=#{prefix}/lib/udev/rules.d",
            "--with-mac-sysroot=" + MacOS.sdk_path,
            "--with-mac-version-min=" + MacOS.version]

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