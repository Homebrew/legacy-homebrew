require "formula"

class Monotone < Formula
  homepage "http://monotone.ca/"
  url "http://www.monotone.ca/downloads/1.1/monotone-1.1.tar.bz2"
  sha1 "2b97559b252decaee3a374b81bf714cf33441ba3"

  bottle do
    revision 1
    sha1 "d8bd7c7c25113e96affe3e8778e1ffd5d5e0ab2c" => :mavericks
    sha1 "82cb04a2b2d06ed074835ad25f928b43a0d87f70" => :mountain_lion
    sha1 "0c0ad8de85f7d9c2139f68914b970ceb38a26929" => :lion
  end

  depends_on "pkg-config" => :build
  depends_on "gettext"
  depends_on "libidn"
  depends_on "lua"
  depends_on "pcre"
  depends_on "botan"
  # Monotone only needs headers, not any built libraries
  depends_on "boost" => :build

  fails_with :llvm do
    build 2334
    cause "linker fails"
  end

  def install
    botan = Formula["botan"]

    ENV["botan_CFLAGS"] = "-I#{botan.opt_include}/botan-1.10"
    ENV["botan_LIBS"] = "-L#{botan.opt_lib} -lbotan-1.10"

    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"

    # Explicitly remove the bash completion script, as it uses features
    # specific to Bash 4, and the default on OS X is Bash 3.
    # Specifically, it uses `declare -A` to declare associate arrays.
    # If this completion script is installed on Bash 3 along with
    # bash-completion, it will be auto-sourced and cause error messages
    # every time a new terminal is opened. See:
    # https://github.com/Homebrew/homebrew/issues/29272
    rm prefix/"etc/bash_completion.d/monotone.bash_completion"
  end
end
