require 'formula'

class Wireshark < Formula
  url 'http://media-2.cacetech.com/wireshark/src/wireshark-1.4.3.tar.bz2'
  md5 'ac3dcc8c128c38d9ef3d9c93d1dec83e'
  homepage 'http://www.wireshark.org'

  depends_on 'gnutls' => :optional
  depends_on 'pcre' => :optional
  depends_on 'glib'
  depends_on 'gtk+' if ARGV.include? "--with-x"

  def options
    [
     ["--with-x", "Include X11 support"],
     ['--with-daemon', 'Include launch daemon that allows admin access to capture devices']
    ]
  end

  def caveats
    if ARGV.include? '--with-daemon'
      'Launch daemon installation program initiated.'
    else
      "If your list of available capture interfaces is empty (behavior on default OS X installation), uninstall and reinstall Wireshark with the '--with-daemon' option. This adds a launch daemon that changes the permissions of your BPF devices so that all users in the 'admin' group - all users with 'Allow user to administer this computer' turned on - have both read and write access to those devices."
    end
  end

  def install
    args = ["--disable-dependency-tracking", "--prefix=#{prefix}"]

    # actually just disables the GTK GUI
    args << "--disable-wireshark" if not ARGV.include? "--with-x"

    system "./configure", *args
    system "make"
    ENV.j1 # Install failed otherwise.
    system "make install"

    if ARGV.include? '--with-daemon'
      system 'wget https://bugs.wireshark.org/bugzilla/attachment.cgi?id=3373 -O ChmodBPF.tar.gz'
      system 'tar zxvf ChmodBPF.tar.gz'
      system 'open ChmodBPF/Install\ ChmodBPF.app'
    end
  end
end

