class Redshift < Formula
  desc "Adjust color temperature of your screen according to your surroundings"
  homepage "http://jonls.dk/redshift/"
  url "https://github.com/jonls/redshift/releases/download/v1.10/redshift-1.10.tar.xz"
  sha256 "5bc2e70aa414f42dafb45c6e06ea90157d7d4b298af48877144ff442639aeea6"

  bottle do
    revision 1
    sha256 "5be5b17938bddcec8b4a01f5b27c433215362172965c4fdef94297a48191e1c5" => :el_capitan
    sha256 "c5a69fc49a3d4913c3333774b3365bcfd3ca841d6aae4d70b6c868ace54108cd" => :yosemite
    sha256 "5433ef625a0df216939ba5bc5af8609e39c5c1704e3cf41ac89bd21c320b8ba2" => :mavericks
  end

  head do
    url "https://github.com/jonls/redshift.git"

    depends_on "automake" => :build
    depends_on "autoconf" => :build
    depends_on "libtool" => :build
  end

  depends_on "pkg-config" => :build
  depends_on "intltool" => :build
  depends_on "gettext"
  depends_on "glib"

  def install
    args = %W[
      --prefix=#{prefix}
      --enable-corelocation
      --disable-silent-rules
      --disable-dependency-tracking
      --disable-geoclue
      --disable-geoclue2
      --enable-quartz
      --with-systemduserunitdir=no
      --disable-gui
    ]

    system "./bootstrap" if build.head?
    system "./configure", *args
    system "make", "install"
  end

  plist_options :manual => "redshift"

  def plist; <<-EOS.undent
    <?xml version="1.0" encoding="UTF-8"?>
    <!DOCTYPE plist PUBLIC "-//Apple Computer//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
    <plist version="1.0">
      <dict>
        <key>Label</key>
        <string>#{plist_name}</string>
        <key>ProgramArguments</key>
        <array>
          <string>#{opt_bin}/redshift</string>
        </array>
        <key>KeepAlive</key>
        <true/>
        <key>RunAtLoad</key>
        <true/>
        <key>StandardErrorPath</key>
        <string>/dev/null</string>
        <key>StandardOutPath</key>
        <string>/dev/null</string>
      </dict>
    </plist>
    EOS
  end

  def caveats; <<-EOS.undent
    A .conf file has not been provided. If you want one, see:
      http://jonls.dk/redshift/
    And place it in #{ENV["HOME"]}/.config
    EOS
  end

  test do
    system "#{bin}/redshift", "-V"
  end
end
