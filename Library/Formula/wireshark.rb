require 'formula'

class Wireshark < Formula
  homepage 'http://www.wireshark.org'
  url 'http://www.wireshark.org/download/src/wireshark-1.8.4.tar.bz2'
  sha1 '00265d9196f030848c78025f30556cd014be843d'
  head 'http://anonsvn.wireshark.org/wireshark/trunk', :using => :svn

  depends_on 'pkg-config' => :build
  depends_on 'gnutls' => :optional
  depends_on 'libgcrypt' => :optional
  depends_on 'c-ares' => :optional
  depends_on 'pcre' => :optional
  depends_on 'glib'

  if build.include? 'with-x'
    depends_on :x11
    depends_on 'gtk+'
  end

  if build.include? 'with-qt'
    depends_on 'qt'
    if not build.head?
      opoo 'with-qt requires --HEAD.'
    end
  end

  option 'with-x', 'Include X11 support'
  option 'with-python', 'Enable experimental Python bindings'
  option 'with-qt', 'Use experimental, incomplete Qt interface, requires --HEAD'

  def install
    args = ["--disable-dependency-tracking", "--prefix=#{prefix}"]

    # Optionally enable experimental python bindings; is known to cause
    # some runtime issues, e.g.
    # "dlsym(0x8fe467fc, py_create_dissector_handle): symbol not found"
    args << '--without-python' unless build.include? 'with-python'

    # actually just disables the GTK GUI
    args << '--disable-wireshark' unless build.include? 'with-x' or build.include? 'with-qt'

    args << '--with-qt' if build.include? 'with-qt'

    system './autogen.sh' if build.head?
    system "./configure", *args
    system "make"
    ENV.deparallelize # parallel install fails
    system "make install"
  end

  def caveats; <<-EOS.undent
    If your list of available capture interfaces is empty
    (default OS X behavior), try the following commands:

      curl https://bugs.wireshark.org/bugzilla/attachment.cgi?id=3373 -o ChmodBPF.tar.gz
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

