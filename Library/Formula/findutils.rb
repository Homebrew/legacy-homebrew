class Findutils < Formula
  desc "Collection of GNU find, xargs, and locate"
  homepage "https://www.gnu.org/software/findutils/"
  url "http://ftpmirror.gnu.org/findutils/findutils-4.6.0.tar.gz"
  mirror "https://ftp.gnu.org/gnu/findutils/findutils-4.6.0.tar.gz"
  sha256 "ded4c9f73731cd48fec3b6bdaccce896473b6d8e337e9612e16cf1431bb1169d"

  bottle do
    revision 2
    sha256 "217c0203656216f069d5bf5487107b9e72824650b090af84694fdd22e001cd28" => :el_capitan
    sha256 "80643a96a454d2ef125a56d3b650ed2331d1a5e6c7f93f442018120519ca2399" => :yosemite
    sha256 "4100412c363ca3964785fe10b74c06ddb3bf7ce0557ad61c915d35833118fd24" => :mavericks
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
