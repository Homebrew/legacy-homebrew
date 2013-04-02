require 'formula'

class Pulseaudio < Formula
  homepage 'http://pulseaudio.org'
  url 'http://freedesktop.org/software/pulseaudio/releases/pulseaudio-3.0.tar.gz'
  sha1 '875ee8c39bb8413007004ffd31f6b35d6508a194'

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
      # It uses `git describe` to set the version string.
      system "ln -s #{cached_download}/.git"
      # For `git describe`, we need the full history and tags.
      # If we already unhallowed earlier, this fails but we can ignore that.
      system "git fetch --unshallow || true"
      system "git fetch --tags"
      system "git describe" # just test
      system "./autogen.sh", *args
    else
      system "./configure", *args
    end

    # remove sconv_neon.c, mix_neon.c because it wont compile (it's ARM Neon related)  and is not needed.
    system "echo > src/pulsecore/sconv_neon.c"
    system "echo > src/pulsecore/mix_neon.c"
    inreplace "src/pulsecore/shm.c", "& 0444", "& 0777" # fix shm_open mode
    system "make"
    system "make install"
  end

  def test
    system "#{bin}/pulseaudio"
  end
end
