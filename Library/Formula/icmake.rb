class Icmake < Formula
  desc "Make utility using a C-line grammar"
  homepage "https://fbb-git.github.io/icmake/"
  url "https://github.com/fbb-git/icmake/archive/7.23.02.tar.gz"
  sha256 "f030086d0630c2c1755519556b9cf88b8495bc8debf36b257e0c69d3b199c46b"

  depends_on "gnu-sed" => :build

  def install
    ENV.prepend_path "PATH", Formula["gnu-sed"].libexec/"gnubin"

    # override the existing file
    (buildpath/"icmake/INSTALL.im").open("w") do |f|
      f.write <<-EOS.undent
        #define BINDIR      "#{bin}"
        #define SKELDIR     "#{share}"
        #define MANDIR      "#{man}"
        // not a typo; the install script puts binaries under LIBDIR/
        #define LIBDIR      "#{bin}"
        #define CONFDIR     "#{etc}"
        #define DOCDIR      "#{doc}"
        #define DOCDOCDIR   "#{doc}"
      EOS
    end

    cd "icmake" do
      system "./icm_bootstrap", "/"
      system "./icm_install", "all", "/"
    end
  end

  test do
    (testpath/"script.im").write <<-EOS.undent
      string TEST;

      void main() {
        TEST = "foobar";
      }
    EOS
    system "#{bin}/icmake", "script.im", (testpath/"test")
  end
end
