class Findutils < Formula
  desc "Collection of GNU find, xargs, and locate"
  homepage "https://www.gnu.org/software/findutils/"
  url "http://ftpmirror.gnu.org/findutils/findutils-4.4.2.tar.gz"
  mirror "https://ftp.gnu.org/gnu/findutils/findutils-4.4.2.tar.gz"
  sha256 "434f32d171cbc0a5e72cfc5372c6fc4cb0e681f8dce566a0de5b6fccd702b62a"

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

    args = ["--prefix=#{prefix}",
            "--localstatedir=#{var}/locate",
            "--disable-dependency-tracking",
            "--disable-debug",
           ]
    args << "--program-prefix=g" if build.without? "default-names"

    system "./configure", *args
    system "make", "install"
  end

  test do
    if build.with? "default-names"
      system "#{bin}/find", "."
    else
      system "#{bin}/gfind", "."
    end
  end
end
