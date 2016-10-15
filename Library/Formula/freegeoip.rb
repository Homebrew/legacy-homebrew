class Freegeoip < Formula
  homepage "https://github.com/fiorix/freegeoip/"
  url "https://github.com/fiorix/freegeoip/archive/v3.0.4.tar.gz"
  sha256 "e4c568135ec305d908bd191eb3885373e6a58f7f6e0a2ae80f2ac80826bb3fe9"

  depends_on "go" => :build

  def install
    (buildpath + "src/github.com/fiorix/freegeoip").install Dir[buildpath/"*"]

    cd "src/github.com/fiorix/freegeoip" do
      ENV["GOPATH"] = buildpath
      system "go", "get", "github.com/fiorix/go-redis/redis"
      system "go", "get", "github.com/fiorix/go-web/httpxtra"
      system "go", "get", "github.com/gorilla/context"

      system "go", "get", "github.com/howeyc/fsnotify"
      system "go", "get", "github.com/oschwald/maxminddb-golang"
      system "go", "get", "github.com/robertkrimen/otto"

      system "go", "build", "-o", "#{buildpath}/freegeoip", "github.com/fiorix/freegeoip/cmd/freegeoip"
    end

    bin.install "freegeoip"
    libexec.install "#{buildpath}/src/github.com/fiorix/freegeoip/cmd/freegeoip/public"
  end

  test do
    assert_equal "freegeoip v3.0.4\n", shell_output("#{bin}/freegeoip --version")
  end

  def caveats; <<-EOS.undent
    You can use public directory from #{libexec}/public starting with argument:
      freegeoip -public=#{libexec}/public
    EOS
  end
end
