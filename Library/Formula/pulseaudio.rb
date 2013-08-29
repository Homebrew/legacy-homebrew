require 'formula'

class Pulseaudio < Formula
  homepage 'http://pulseaudio.org'
  url 'http://freedesktop.org/software/pulseaudio/releases/pulseaudio-4.0.tar.gz'
  sha1 'f076d91194066daf8d458048c2ce6867ce38f2cd'

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
  depends_on 'dbus' => :optional

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

    # remove sconv_neon.c, mix_neon.c because it wont compile (it's ARM Neon related) and is not needed.
    # see <https://bugs.freedesktop.org/show_bug.cgi?id=62986>.
    system "echo > src/pulsecore/sconv_neon.c"
    system "echo > src/pulsecore/mix_neon.c"

    system "make"
    system "make install"
  end

  def caveats; <<-EOS.undent
    Edit `/usr/local/etc/pulse/default.pa` and remove the "module-detect" parts.
    You might want to add these:

        # Detect the CoreAudio soundcard.
        load-module module-coreaudio-detect
        # Listen on TCP port 4713.
        # Note that this allows anonymous access from any network!
        load-module module-native-protocol-tcp auth-anonymous=1

    In `/usr/local/etc/pulse/daemon.conf`, you might want to set:

        # Disable autoexit on idle.
        exit-idle-time = -1
    EOS
  end

  def test
    system "#{bin}/pulseaudio"
  end
end
