class Caf < Formula
  homepage "http://actor-framework.org"
  url "https://github.com/actor-framework/actor-framework/archive/0.12.0.tar.gz"
  sha256 "de927f53f5765489406d636dcf042bf3f281bc75ebfe4fce933dc1d9cff60481"
  head "https://github.com/actor-framework/actor-framework.git"

  devel do
    url "https://github.com/actor-framework/actor-framework.git",
      :branch => "develop"
    version "0.13-devel"
  end

  depends_on "cmake" => :build

  option "with-static", "build as static and shared library"
  option "with-static-only", "build as static library only"
  option "with-log-level-error", "build with log level ERROR"
  option "with-log-level-warning", "build with log level WARNING"
  option "with-log-level-info", "build with log level INFO"
  option "with-log-level-debug", "build with log level DEBUG"
  option "with-log-level-trace", "build with log level TRACE"

  def install
    args = ["./configure", "--prefix=#{prefix}", "--no-examples"]
    args << "--build-static" if build.with? "static"
    args << "--build-static-only" if build.with? "static-only"
    args << "--with-log-level=ERROR" if build.with? "log-level-error"
    args << "--with-log-level=WARNING" if build.with? "log-level-warning"
    args << "--with-log-level=INFO" if build.with? "log-level-info"
    args << "--with-log-level=DEBUG" if build.with? "log-level-debug"
    args << "--with-log-level=TRACE" if build.with? "log-level-trace"

    # Clear state from previous builds to allow for changing build options.
    system "make", "distclean" if File.exist?("Makefile")

    system *args
    system "make"
    system "make", "test"
    system "make", "install"
  end
end
