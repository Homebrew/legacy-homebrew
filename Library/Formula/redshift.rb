class Redshift < Formula
  homepage "http://jonls.dk/redshift/"
  url "https://github.com/jonls/redshift/archive/59023d86f4275128751bcb84ecda5a630bf51857.tar.gz"
  version "1.9.1.59023d8"
  sha1 "66a3a6011cdccb0b9ee77fde0de65da437c72ec5"
  head "https://github.com/jonls/redshift.git"

    depends_on "automake" => :build
  depends_on "autoconf" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "intltool" => :build
  depends_on "gettext"
  depends_on "glib"

  def install
    # Despite the naming, 'quartz' here does not = x11 dep.
    args = %W[
      --prefix=#{prefix}
      --sysconfdir=#{etc}/redshift
      --enable-corelocation
      --disable-silent-rules
      --disable-dependency-tracking
      --disable-geoclue2
      --enable-quartz
      --with-systemduserunitdir=no
      --disable-gui
    ]

    system "./bootstrap"
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
          <string>#{bin}/redshift</string>
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
    And place it in #{etc}/redshift
    EOS
  end

  test do
    system "#{bin}/redshift", "-V"
  end
end
