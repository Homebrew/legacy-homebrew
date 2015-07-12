class Nmh < Formula
  desc "Powerful electronic mail handling system"
  homepage "http://www.nongnu.org/nmh/"
  url "http://download.savannah.nongnu.org/releases/nmh/nmh-1.6.tar.gz"
  sha256 "29338ae2bc8722fe8a5904b7b601a63943b72b07b6fcda53f3a354edb6a64bc3"

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
    system "install-mh -auto"
  end

  test do
    # `test do` will create, run in and delete a temporary directory.
    #
    # This test will fail and we won't accept that! It's enough to just replace
    # "false" with the main program this formula installs, but it'd be nice if you
    # were more thorough. Run the test with `brew test nmh`. Options passed
    # to `brew install` such as `--HEAD` also need to be provided to `brew test`.
    #
    # The installed folder is not in the path, so use the entire path to any
    # executables being tested: `system "#{bin}/program", "do", "something"`.
    system "inc -help"
    system "scan -help"
    system "rmm -help"
    system "comp -help"
    system "repl -help"
  end
end
