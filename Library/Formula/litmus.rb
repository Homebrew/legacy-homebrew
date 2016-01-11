class Litmus < Formula
  desc "WebDAV server protocol compliance test suite"
  homepage "http://www.webdav.org/neon/litmus/"
  url "http://www.webdav.org/neon/litmus/litmus-0.13.tar.gz"
  sha256 "09d615958121706444db67e09c40df5f753ccf1fa14846fdeb439298aa9ac3ff"

  def install
    # Note that initially this formula also had the --disable-debug option
    # passed to ./configure.
    #
    # This disabled a critical feature. Litmus is a debugging tool, and this
    # caused all logs to be empty by default.
    #
    # See: https://github.com/Homebrew/homebrew/pull/29608
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end
end
