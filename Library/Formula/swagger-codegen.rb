class SwaggerCodegen < Formula
  desc "Generation of client and server from Swagger definition"
  homepage "http://swagger.io/swagger-codegen/"
  url "https://github.com/swagger-api/swagger-codegen/archive/v2.1.4.tar.gz"
  sha256 "b4965158fb8abbebdfcaab2fdc0c5556001c587a526279d44ea9878f7ef9ef4c"
  head "https://github.com/swagger-api/swagger-codegen.git"

  depends_on :java => "1.7"
  depends_on "maven" => :build

  def install
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
