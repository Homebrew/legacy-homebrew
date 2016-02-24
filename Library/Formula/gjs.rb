class Gjs < Formula
  desc "Javascript Bindings for GNOME"
  homepage "https://wiki.gnome.org/Projects/Gjs"
  url "https://download.gnome.org/sources/gjs/1.44/gjs-1.44.0.tar.xz"
  sha256 "88c960f6ad47a6931d123f5d6317d13704f58572f68a4391913a254ff27dce80"

  bottle do
    revision 1
    sha256 "fb613d40633ad455a5a057d8ea196b6fd602bfd3c5920bb917783f413f0982d0" => :el_capitan
    sha256 "dfcf484bc4ccbf5d3e6db92247d963712609d7d8d821b8046843899368f9aef1" => :yosemite
    sha256 "dab6d6305eb3d8046b7f87659b5c3207bb309787a7f58d64a9c018fab78f6437" => :mavericks
  end

  depends_on "pkg-config" => :build
  depends_on "gobject-introspection"
  depends_on "nspr"
  depends_on "readline"
  depends_on "gtk+3" => :recommended

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
