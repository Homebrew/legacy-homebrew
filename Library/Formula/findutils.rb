class Findutils < Formula
  desc "Collection of GNU find, xargs, and locate"
  homepage "https://www.gnu.org/software/findutils/"
  url "http://ftpmirror.gnu.org/findutils/findutils-4.6.0.tar.gz"
  mirror "https://ftp.gnu.org/gnu/findutils/findutils-4.6.0.tar.gz"
  sha256 "ded4c9f73731cd48fec3b6bdaccce896473b6d8e337e9612e16cf1431bb1169d"

  bottle do
    cellar :any_skip_relocation
    sha256 "e6120861e27d3fabc684f47a848269b959c8353b071bcacca2cb21298abae543" => :el_capitan
    sha256 "3f6ba384bb5f22e14c5474f21940154a289d075c3aac4e8299d8dc9112ac87c3" => :yosemite
    sha256 "2869b60125ff5b945131d2654f5245967d5887d8f1003bccb02270369ad8550c" => :mavericks
  end

  deprecated_option "default-names" => "with-default-names"

  option "with-default-names", "Do not prepend 'g' to the binary"

  def install
    # Work around unremovable, nested dirs bug that affects lots of
    # GNU projects. See:
    # https://github.com/Homebrew/homebrew/issues/45273
    # https://github.com/Homebrew/homebrew/issues/44993
    # This is thought to be an el_capitan bug:
    # http://lists.gnu.org/archive/html/bug-tar/2015-10/msg00017.html
    if MacOS.version == :el_capitan
      ENV["gl_cv_func_getcwd_abort_bug"] = "no"
    end

    args = %W[
      --prefix=#{prefix}
      --localstatedir=#{var}/locate
      --disable-dependency-tracking
      --disable-debug
    ]
    args << "--program-prefix=g" if build.without? "default-names"

    system "./configure", *args
    system "make", "install"

    # https://savannah.gnu.org/bugs/index.php?46846
    # https://github.com/Homebrew/homebrew/issues/47791
    updatedb = (build.with?("default-names") ? "updatedb" : "gupdatedb")
    (libexec/"bin").install bin/"#{updatedb}"
    (bin/updatedb).write <<-EOS.undent
      #!/bin/sh
      export LC_ALL='C'
      exec "#{libexec}/bin/#{updatedb}" "$@"
    EOS
  end

  def post_install
    (var/"locate").mkpath
  end

  test do
    find = (build.with?("default-names") ? "find" : "gfind")
    touch "HOMEBREW"
    assert_match "HOMEBREW", shell_output("#{bin}/#{find} .")
  end
end
