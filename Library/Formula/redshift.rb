class Redshift < Formula
  desc "Adjust color temperature of your screen according to your surroundings"
  homepage "http://jonls.dk/redshift/"
  url "https://github.com/jonls/redshift/releases/download/v1.11/redshift-1.11.tar.xz"
  sha256 "10e350f93951c0521dd6f103d67a485972c307214f036e009acea2978fe4f359"

  bottle do
    sha256 "f8fc6b6b2279982aefc06a03571c8de76df9542808558e542e87d7e28187d58f" => :el_capitan
    sha256 "b51cd606ac04a3709ca9a02196c26ee6b79b1b32d976ef01155db382f5145f81" => :yosemite
    sha256 "9d151b44efdd166ae4239af7dff907a4868441c126f7fd11aa69a53e9d39de7a" => :mavericks
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
    pkgshare.install "redshift.conf.sample"
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
    A sample .conf file has been installed to #{opt_pkgshare}.

    Please note redshift expects to read its configuration file from
    #{ENV["HOME"]}/.config
    EOS
  end

  test do
    system "#{bin}/redshift", "-V"
  end
end
