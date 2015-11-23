class Redshift < Formula
  desc "Adjusts color temperature of your screen according to your surroundings"
  homepage "http://jonls.dk/redshift/"
  url "https://github.com/jonls/redshift/releases/download/v1.10/redshift-1.10.tar.xz"
  sha256 "5bc2e70aa414f42dafb45c6e06ea90157d7d4b298af48877144ff442639aeea6"

  bottle do
    sha1 "1cb7c9779ea9bbd693deed7c74187efe45e1a924" => :yosemite
    sha1 "699455a7634fb9ad524c4cdc9bafa7c4561b8de4" => :mavericks
    sha1 "4fc7ff402d12a09ab6abc2a9c91ee03b2483cc8d" => :mountain_lion
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
    And place it in $HOME/.config
    EOS
  end

  test do
    system "#{bin}/redshift", "-V"
  end
end
