require 'formula'

class Wireshark < Formula
  url 'http://wiresharkdownloads.riverbed.com/wireshark/src/wireshark-1.7.0.tar.bz2'
  md5 'c9f646a15fed6e31c4aa88322b8cce2a'
  homepage 'http://www.wireshark.org'

  depends_on 'gnutls' => :optional
  depends_on 'pcre' => :optional
  depends_on 'glib'
  depends_on 'gtk+' if ARGV.include? "--with-x"

  def options
    [["--with-x", "Include X11 support"]]
  end

  def install
    args = ["--disable-dependency-tracking", "--prefix=#{prefix}"]

    # actually just disables the GTK GUI
    args << "--disable-wireshark" if not ARGV.include? "--with-x"

    system "./configure", *args
    system "make"
    ENV.j1 # Install failed otherwise.
    system "make install"
  end

  def caveats; <<-EOS.undent
      If your list of available capture interfaces is empty
      (default OS X behavior), try the following commands:

        wget https://bugs.wireshark.org/bugzilla/attachment.cgi?id=3373 -O ChmodBPF.tar.gz
        tar zxvf ChmodBPF.tar.gz
        open ChmodBPF/Install\\ ChmodBPF.app

      This adds a launch daemon that changes the permissions of your BPF
      devices so that all users in the 'admin' group - all users with
      'Allow user to administer this computer' turned on - have both read
      and write access to those devices.

      See bug report:
        https://bugs.wireshark.org/bugzilla/show_bug.cgi?id=3760
    EOS
  end
end

