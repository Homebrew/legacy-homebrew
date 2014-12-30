class Libyaml < Formula
  homepage "http://pyyaml.org/wiki/LibYAML"
  url "http://pyyaml.org/download/libyaml/yaml-0.1.6.tar.gz"
  mirror "https://mirrors.kernel.org/debian/pool/main/liby/libyaml/libyaml_0.1.6.orig.tar.gz"
  sha1 "f3d404e11bec3c4efcddfd14c42d46f1aabe0b5d"

  bottle do
    cellar :any
    revision 1
    sha1 "1d30f0a8143ef4b66d4bbc07a739039ab216f2a2" => :yosemite
    sha1 "59463ec0044fa00929d7bb272e8ed4aa202c57cf" => :mavericks
    sha1 "6cf822fb1c5377243dfe458fb663800612a4b131" => :mountain_lion
  end

  option :universal

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
