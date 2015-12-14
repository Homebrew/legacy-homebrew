class Gjs < Formula
  desc "Javascript Bindings for GNOME"
  homepage "https://wiki.gnome.org/Projects/Gjs"
  url "https://download.gnome.org/sources/gjs/1.44/gjs-1.44.0.tar.xz"
  sha256 "88c960f6ad47a6931d123f5d6317d13704f58572f68a4391913a254ff27dce80"

  bottle do
    sha256 "064d5c01e71abb4d7ea8fa83cf6d12649a1285b15087ad73e9f3d00895e8921f" => :el_capitan
    sha256 "42c41dab3869b1db0993362682c2319ba743b6dcc3fbeb840c65f736b4928a63" => :yosemite
    sha256 "de191dae86b0ce0185ac6061784caae913eb3dbd5bb27276363bdb9f19db3de4" => :mavericks
  end

  depends_on "pkg-config" => :build
  depends_on "gobject-introspection"
  depends_on "nspr"
  depends_on "readline"

  resource "mozjs24" do
    url "https://ftp.mozilla.org/pub/mozilla.org/js/mozjs-24.2.0.tar.bz2"
    sha256 "e62f3f331ddd90df1e238c09d61a505c516fe9fd8c5c95336611d191d18437d8"
  end

  def install
    resource("mozjs24").stage do
      cd("js/src") do
        # patches taken from MacPorts
        # fixes a problem with Perl 5.22
        inreplace "config/milestone.pl", "if (defined(@TEMPLATE_FILE)) {", "if (@TEMPLATE_FILE) {"
        # use absolute path for install_name, don't assume will be put into an app bundle
        inreplace "config/rules.mk", "@executable_path", "${prefix}/lib"
        system "./configure", "--disable-debug",
                              "--disable-dependency-tracking",
                              "--disable-silent-rules",
                              "--prefix=#{prefix}",
                              "--with-system-nspr",
                              "--enable-readline",
                              "--enable-threadsafe"
        system "make"
        system "make", "install"
        rm Dir["#{bin}/*"]
      end
      ENV.append_path "PKG_CONFIG_PATH", "#{lib}/pkgconfig"
    end
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"test.js").write <<-EOS.undent
      #!/usr/bin/env gjs
      const GLib = imports.gi.GLib;
    EOS
    system "#{bin}/gjs", "test.js"
  end
end
