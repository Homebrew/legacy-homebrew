class Confuse < Formula
  desc "Configuration file parser library written in C"
  homepage "https://github.com/martinh/libconfuse"
  url "https://github.com/martinh/libconfuse/releases/download/v2.8/confuse-2.8.tar.xz"
  sha256 "2a8102bfa3ccc846c14d94a81b0abfb4f5e855809f89ff3722aca1a9f314ea0d"

  bottle do
    cellar :any
    sha256 "dac00feeb2cd3cb2897afab338d01e84e8132a89e2bbe5d23cf5169f6c92b3b0" => :el_capitan
    sha256 "0998a46243bfb613e3cc0c7a7d2534e88dc0a89a69b820c0dea20da7f54ccee8" => :yosemite
    sha256 "321babd2b297a0892906647860d8443487420b2ed36b62339cf2ae1bb5c9921f" => :mavericks
  end

  depends_on "pkg-config" => :build

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "check"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<-EOS.undent
      #include <confuse.h>
      #include <stdio.h>

      cfg_opt_t opts[] =
      {
        CFG_STR("hello", NULL, CFGF_NONE),
        CFG_END()
      };

      int main(void)
      {
        cfg_t *cfg = cfg_init(opts, CFGF_NONE);
        if (cfg_parse_buf(cfg, "hello=world") == CFG_SUCCESS)
          printf("%s\\n", cfg_getstr(cfg, "hello"));
        cfg_free(cfg);
        return 0;
      }
    EOS
    system ENV.cc, "test.c", "-lconfuse", "-o", "test"
    assert_match /world/, shell_output("./test")
  end
end
