class Libyaml < Formula
  desc "YAML Parser"
  homepage "http://pyyaml.org/wiki/LibYAML"
  url "http://pyyaml.org/download/libyaml/yaml-0.1.6.tar.gz"
  mirror "https://mirrors.kernel.org/debian/pool/main/liby/libyaml/libyaml_0.1.6.orig.tar.gz"
  sha256 "7da6971b4bd08a986dd2a61353bc422362bd0edcc67d7ebaac68c95f74182749"
  revision 1

  bottle do
    cellar :any
    sha256 "557b32dbf6e6798972e6f9594a91cca044f90f92f410e0eb3ebcbee199f781aa" => :el_capitan
    sha256 "f3c705e4f5790e6340f9c673100a855b16b4603821d711dedf7b2b07e30dfe18" => :yosemite
    sha256 "dcf99044b9c72eb2c1a1017fdbd9020e48f26dc3d9bd7d88aa497b98fdbccd96" => :mavericks
    sha256 "7339f312e5b9011acd518b2bee0008439be8bbd697fe4f4944ea3a2137a41652" => :mountain_lion
  end

  option :universal

  # address CVE-2014-9130
  # https://web.nvd.nist.gov/view/vuln/detail?vulnId=CVE-2014-9130
  patch do
    url "https://bitbucket.org/xi/libyaml/commits/2b9156756423e967cfd09a61d125d883fca6f4f2/raw/"
    sha256 "30546a280c4f9764a93ff5f4f88671a02222e9886e7f63ee19aebf1b2086a7fe"
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
