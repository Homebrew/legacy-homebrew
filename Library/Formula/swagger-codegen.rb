class SwaggerCodegen < Formula
  desc "Generation of client and server from Swagger definition"
  homepage "http://swagger.io/swagger-codegen/"
  url "https://github.com/swagger-api/swagger-codegen/archive/v2.1.5.tar.gz"
  sha256 "0af11ac04552114ad8d185a2bbedbd961aef1d9e69f7eec7ac27602675844f68"
  head "https://github.com/swagger-api/swagger-codegen.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "f04e9018a8bba33e36d7a5471d65f24babc7a02df9cfdb5dd82254bda9e58463" => :el_capitan
    sha256 "1a98508472336a5bfce372478ec4005049598e5114e2d66a34cc42624e759700" => :yosemite
    sha256 "762cf623888094cf888a78d711a0218faac73a997df6e408f62dfad0421e1cc5" => :mavericks
  end

  depends_on :java => "1.7+"
  depends_on "maven" => :build

  def install
    ENV.java_cache

    system "mvn", "clean", "package"
    libexec.install "modules/swagger-codegen-cli/target/swagger-codegen-cli.jar"
    bin.write_jar_script libexec/"swagger-codegen-cli.jar", "swagger-codegen"
  end

  test do
    (testpath/"minimal.yaml").write <<-EOS.undent
      ---
      swagger: '2.0'
      info:
        version: 0.0.0
        title: Simple API
      paths:
        /:
          get:
            responses:
              200:
                description: OK
    EOS
    system "#{bin}/swagger-codegen", "generate", "-i", "minimal.yaml", "-l", "swagger"
  end
end
