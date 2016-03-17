class Nu < Formula
  desc "Object-oriented, Lisp-like programming language"
  homepage "http://programming.nu"
  url "https://github.com/timburks/nu/archive/v2.1.1.tar.gz"
  sha256 "5bdf8234855ecdec54b716c806a332c78812c73c8e7f626520dd273382d3de17"

  bottle do
    cellar :any
    revision 1
    sha256 "6db4fa8bafc2110e16cb7b8ae675e4e25483cb3d05b7f15535ae3cabe25f48d2" => :el_capitan
    sha256 "6934ad8b4e7a1baa21939975a82b5fb2b4ec8d7462bb9c4237004dd10c05d9d4" => :yosemite
    sha256 "c6075aa6a0ea3a36067295f9e9e16fca5ec0d4c79db5f7c5fde19e774a24f69e" => :mavericks
  end

  depends_on :macos => :lion
  depends_on "pcre"

  fails_with :llvm do
    build 2336
    cause "nu only builds with clang"
  end

  fails_with :gcc do
    build 5666
    cause "nu only builds with clang"
  end

  # remove deprecated -fobjc-gc
  # https://github.com/timburks/nu/pull/74
  # https://github.com/Homebrew/homebrew/issues/37341
  patch do
    url "https://github.com/timburks/nu/commit/c0b05f1.diff"
    sha256 "f6c1a66e470e7132ba11937c971f9b90824bb03eaa030b3e70004f9d2725c636"
  end

  def install
    ENV["PREFIX"] = prefix

    inreplace "Nukefile" do |s|
      s.gsub!('(SH "sudo ', '(SH "') # don't use sudo to install
      s.gsub!("\#{@destdir}/Library/Frameworks", "\#{@prefix}/Frameworks")
      s.sub! /^;; source files$/, <<-EOS
;; source files
(set @framework_install_path "#{frameworks}")
EOS
    end
    system "make"
    system "./mininush", "tools/nuke"
    bin.mkdir
    lib.mkdir
    include.mkdir
    system "./mininush", "tools/nuke", "install"
  end

  def caveats; <<-EOS.undent
    Nu.framework was installed to:
      #{frameworks}/Nu.framework

    You may want to symlink this Framework to a standard OS X location,
    such as:
      ln -s "#{frameworks}/Nu.framework" /Library/Frameworks
  EOS
  end

  test do
    system bin/"nush", "-e", '(puts "Everything old is Nu again.")'
  end
end
