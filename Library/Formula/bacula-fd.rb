class BaculaFd < Formula
  desc "Network backup solution"
  homepage "http://www.bacula.org/"
  url "https://downloads.sourceforge.net/project/bacula/bacula/7.2.0/bacula-7.2.0.tar.gz"
  sha256 "818606fe69c50c3ca21b91e609d4ac6ca08e4189419b89d3ec2e81c8c0389e1c"

  bottle do
    sha1 "aa312ee016437c22b7e4955c67defa51c7703540" => :yosemite
    sha1 "400280627f03404732bf3db7a5612bfab5fe3876" => :mavericks
    sha1 "9ac0bc82522ce93b349a71d2f0cfeac4d6501545" => :mountain_lion
  end

  depends_on "readline"
  depends_on "openssl"

  def install
    inreplace "./src/filed/acl.c", "STREAM_ACL_DARWIN_ACCESS_ACL", "STREAM_ACL_DARWIN_ACCESS"
    # * sets --disable-conio in order to force the use of readline
    #   (conio support not tested)
    # * working directory in /var/lib/bacula, reasonable place that
    #   matches Debian's location.
    readline = Formula["readline"].opt_prefix
    system "./configure", "--prefix=#{prefix}",
                          "--sbindir=#{bin}",
                          "--with-working-dir=#{var}/lib/bacula",
                          "--with-pid-dir=#{HOMEBREW_PREFIX}/var/run",
                          "--enable-client-only",
                          "--disable-conio",
                          "--with-readline=#{readline}"

    system "make"
    system "make", "install"

    # Ensure var/run exists:
    (var + "run").mkpath

    # Create the working directory:
    (var + "lib/bacula").mkpath
  end
end
