class Libyaml < Formula
  desc "YAML Parser"
  homepage "http://pyyaml.org/wiki/LibYAML"
  url "http://pyyaml.org/download/libyaml/yaml-0.1.6.tar.gz"
  mirror "https://mirrors.kernel.org/debian/pool/main/liby/libyaml/libyaml_0.1.6.orig.tar.gz"
  sha1 "f3d404e11bec3c4efcddfd14c42d46f1aabe0b5d"
  revision 1

  bottle do
    cellar :any
    sha1 "fe12271b6ad73806e26dd5e1c7d9090c739361a1" => :yosemite
    sha1 "c1db85f1e26699b0788cea8383fba127cfb4c83b" => :mavericks
    sha1 "5b2af750962a1cdc36384f49d2fe96b0f00d5fda" => :mountain_lion
  end

  option :universal

  # address CVE-2014-9130
  # https://web.nvd.nist.gov/view/vuln/detail?vulnId=CVE-2014-9130
  patch do
    url "https://bitbucket.org/xi/libyaml/commits/2b9156756423e967cfd09a61d125d883fca6f4f2/raw/"
    sha1 "174dbe1f5161853cdb1c6ba94df6a826cf25870c"
  end

  def install
    ENV.universal_binary if build.universal?

    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<-EOS.undent
      #include <yaml.h>

      int main()
      {
        yaml_parser_t parser;
        yaml_parser_initialize(&parser);
        yaml_parser_delete(&parser);
        return 0;
      }
    EOS
    system ENV.cc, "test.c", "-lyaml", "-o", "test"
    system "./test"
  end
end
