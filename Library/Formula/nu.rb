class Nu < Formula
  desc "Object-oriented, Lisp-like programming language"
  homepage "http://programming.nu"
  url "https://github.com/timburks/nu/archive/v2.1.1.tar.gz"
  sha256 "5bdf8234855ecdec54b716c806a332c78812c73c8e7f626520dd273382d3de17"

  bottle do
    cellar :any
    sha256 "a9aeea629392e001f68e5b0155fd74f3ed0ce09bbb654f43236db2ee767521b9" => :yosemite
    sha256 "21c6f4cecd22bb7ebf67dde5e37bbf5dfbc7f7da348f83c7c161480c0c442728" => :mavericks
    sha256 "8311472e5ad2d30ac1c30b960b97981c76b6a0e655b2870dd721e808b351d297" => :mountain_lion
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
      s.gsub!("#{@destdir}/Library/Frameworks", "#{@prefix}/Frameworks")
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

  def caveats
    if self.installed? && File.exist?(frameworks+"Nu.framework")
      return <<-EOS.undent
        Nu.framework was installed to:
          #{frameworks}/Nu.framework

        You may want to symlink this Framework to a standard OS X location,
        such as:
          ln -s "#{frameworks}/Nu.framework" /Library/Frameworks
      EOS
    end
    nil
  end

  test do
    system bin/"nush", "-e", '(puts "Everything old is Nu again.")'
  end
end
