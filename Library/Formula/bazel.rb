#
# Brew Formula for Google's Bazel
# written by Felix Klein <me@felixklein.at>
#

class Bazel < Formula
  homepage "http://bazel.io/"

  #
  # Version: Bazel 0.0.2 (latest tag from GitHub)
  # This version is quite old, however there are no newer tags available on GitHub.
  #
  url "https://github.com/google/bazel/archive/0.0.2.tar.gz"
  sha256 "5865356e74622c248248174acd09f38c07f3983867d7e687fa5932f2216e84c0"
  version "0.0.2"

  #
  # Use userpaths, otherwise the build script doesn't find the libarchive library
  #
  env :userpaths

  #
  # Dependencies
  #
  depends_on "protobuf" => :build
  depends_on "libarchive"

  #
  # Install the latest version from GitHub, if the user passes the --HEAD argument
  #
  head do
    url "https://github.com/google/bazel.git", :using => :git
  end

  #
  # Set flags for optimization, and build with supplied build scripts
  # Install the bazel binary
  #
  def install
    ENV.append_to_cflags "-Ofast -march=native -flto"
    system "./compile.sh"
    system "./output/bazel help"
    bin.install "./output/bazel"
  end

  #
  # Warn the user that this is potentially unstable software
  #
  def caveats
    "This software is still in Alpha, visit http://bazel.io/ for more information."
  end

  #
  # Runn the supplied test script
  #
  test do
    system "./bootstrap_test.sh test"
  end
end
