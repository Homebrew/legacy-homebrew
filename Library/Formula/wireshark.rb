require 'formula'

class Wireshark <Formula
  url 'http://media-2.cacetech.com/wireshark/src/wireshark-1.4.3.tar.bz2'
  md5 'ac3dcc8c128c38d9ef3d9c93d1dec83e'
  homepage 'http://www.wireshark.org'

  depends_on 'gnutls' => :optional
  depends_on 'pcre' => :optional
  depends_on 'glib'
  depends_on 'gtk+' if ARGV.include? "--with-x"

  def options
    [["--with-x", "Include X11 support"]]
  end

  def caveats
    "If your list of available capture interfaces is empty (behavior on default OS X installation), try the following commands: 
  wget https://bugs.wireshark.org/bugzilla/attachment.cgi?id=3373 -O ChmodBPF.tar.gz
  tar zxvf ChmodBPF.tar.gz
  open ChmodBPF/Install\\ ChmodBPF.app
This adds a launch daemon that changes the permissions of your BPF devices so that all users in the 'admin' group - all users with 'Allow user to administer this computer' turned on - have both read and write access to those devices. See bug report:
https://bugs.wireshark.org/bugzilla/show_bug.cgi?id=3760"
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
end

