class Unicorn < Formula
  desc "A lightweight multi-platform, multi-architecture CPU emulation framework"
  head "https://github.com/unicorn-engine/unicorn.git"
  url "https://github.com/unicorn-engine/unicorn/archive/0.9.tar.gz"
  sha256 "1ca03b1c8f6360335567b528210713461e839d47c4eb7c676ba3aa4f72b8cf10"
  homepage "http://www.unicorn-engine.org"

  depends_on 'capstone'
  depends_on 'glib'
  depends_on 'pkg-config' => :build
  depends_on 'python'

  option "debug", "Create a debug build"
  option "without-x86", "Build without x86 support"
  option "without-x86_64", "Build without x86_64 support"
  option "without-static", "Don't build static libraries"
  option "with-all", "Build with complete architectural support"
  option "with-arm", "Build with ARM support"
  option "with-aarch64", "Build with ARM64 support"
  option "with-m68k", "Build with Motorola 68000 support"
  option "with-mips", "Build with MIPS support"
  option "with-ppc", "Build with PowerPC support"
  option "with-shared", "Build with shared library support"
  option "with-sparc", "Build with SPARC support"

  def install
    archs = []
    ['x86', 'x86_64'].each do |arch|
      archs << arch if build.with? arch
    end
    ['arm', 'aarch64', 'm64k', 'mips', 'ppc', 'sparc'].each do |arch|
      if build.with? 'all' or build.with? arch
        archs << arch
      end
    end
    ENV['PREFIX'] = prefix
    ENV['UNICORN_ARCHS'] = archs.join ' '
    ['static', 'shared', 'debug'].each do |condition|
      ENV["UNICORN_#{condition.upcase}"] = build.with?(condition) ? 'yes' : 'no'
    end
    system "make", "install"
  end
end
