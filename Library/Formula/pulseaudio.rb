require 'formula'

class Pulseaudio < Formula
  homepage 'http://pulseaudio.org'
  url 'http://freedesktop.org/software/pulseaudio/releases/pulseaudio-2.1.tar.gz'
  sha1 '957399478456c1dd5632bc84e9ee06a07a9c4c9c'

  head 'git://anongit.freedesktop.org/pulseaudio/pulseaudio'

  option "with-dbus", "Enable dbus"

  # Dependencies from http://www.freedesktop.org/wiki/Software/PulseAudio/Ports/OSX
  if build.head?
    depends_on :autoconf
    depends_on :automake
    depends_on :libtool
  end

  depends_on 'pkg-config' => :build
  depends_on 'intltool' => :build
  depends_on 'libsndfile'
  depends_on 'speex'
  depends_on 'gdbm'
  depends_on 'liboil'
  depends_on 'json-c'
  depends_on 'dbus' if build.include? 'with-dbus'

  def install
    args = ["--prefix=#{prefix}",
            "--disable-jack",
            "--disable-hal",
            "--disable-bluez",
            "--disable-avahi",
            "--with-udev-rules-dir=#{lib}/udev/rules.d",
            "--with-mac-sysroot=#{MacOS.sdk_path}",
            "--with-mac-version-min=#{MacOS.version}"]

    args << '--disable-dbus' unless build.include? 'with-dbus'
    args << "--disable-nls" if build.head? and not Formula.factory('libtool').installed?

    if build.head? then
      system "./autogen.sh", *args
    else
      system "./configure", *args
    end

    system "make"
    system "make install"
  end

  def test
    system "#{bin}/pulseaudio"
  end
end
