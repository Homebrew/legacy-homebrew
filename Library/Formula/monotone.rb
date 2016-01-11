class Monotone < Formula
  desc "Distributed version control system (DVCS)"
  homepage "http://monotone.ca/"
  url "http://www.monotone.ca/downloads/1.1/monotone-1.1.tar.bz2"
  sha256 "f95cf60a22d4e461bec9d0e72f5d3609c9a4576fb1cc45f553d0202ce2e38c88"
  revision 1

  bottle do
    sha256 "18ddf756a5fdf3b733a3f8f2f2ad04f535f2bf161433bdf724b4ee732057d8ce" => :mavericks
    sha256 "a387b6d5d81c5eb8d452b29e9a2b81d9772fb7d97196b9c2a74baa84799e6b0c" => :mountain_lion
    sha256 "6156cae8c108a19859b5efffe962ceafe908d7cd6a2a38286f772d91349303b8" => :lion
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
    system "make", "install"

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
