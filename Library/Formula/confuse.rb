class Confuse < Formula
  desc "Configuration file parser library written in C"
  homepage "https://github.com/martinh/libconfuse"
  url "https://github.com/martinh/libconfuse/releases/download/v2.8/confuse-2.8.tar.xz"
  sha256 "2a8102bfa3ccc846c14d94a81b0abfb4f5e855809f89ff3722aca1a9f314ea0d"

  bottle do
    cellar :any_skip_relocation
    revision 1
    sha256 "0df403420102e0215a8c2c98d091c1dc8f88d4b384a29cb9b4933c4a24448a31" => :el_capitan
    sha256 "2d474d4e4e735c0b359424164f6458e07101b6ce051bd018b88e2bfb1f8571d1" => :yosemite
    sha256 "d365907b21e36075ce3980b8ab8f5131da731f6f992869b41227be34256f15b1" => :mavericks
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
