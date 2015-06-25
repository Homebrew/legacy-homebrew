require "language/go"

class Grafana < Formula
  homepage "http://www.grafana.org/"
  url "https://github.com/grafana/grafana/archive/v2.0.2.tar.gz"
  sha256 "e2e1b502b7ea9b7342defd82af9ff81d93670b3049c81fb240235df658a7f8db"
  head "https://github.com/grafana/grafana.git"
  version "2.0.2"

  depends_on "node"
  depends_on "go" => :build

  go_resource "github.com/Unknwon/com" do
    url "https://github.com/Unknwon/com.git",
      :revision => "d9bcf409c8a368d06c9b347705c381e7c12d54df"
  end
  go_resource "github.com/Unknwon/macaron" do
    url "https://github.com/Unknwon/macaron.git",
      :revision => "93de4f3fad97bf246b838f828e2348f46f21f20a"
  end
  go_resource "github.com/codegangsta/cli" do
    url "https://github.com/codegangsta/cli.git",
      :revision => "9908e96513e5a94de37004098a3974a567f18111"
  end
  go_resource "github.com/go-sql-driver/mysql" do
    url "https://github.com/go-sql-driver/mysql.git",
      :revision => "9543750295406ef070f7de8ae9c43ccddd44e15e"
  end
  go_resource "github.com/go-xorm/core" do
    url "https://github.com/go-xorm/core.git",
      :revision => "be6e7ac47dc57bd0ada25322fa526944f66ccaa6"
  end
  go_resource "github.com/go-xorm/xorm" do
    url "https://github.com/go-xorm/xorm.git",
      :revision => "e2889e5517600b82905f1d2ba8b70deb71823ffe"
  end
  go_resource "github.com/gosimple/slug" do
    url "https://github.com/gosimple/slug.git",
      :revision => "a2392a4a87fa0366cbff131d3fd421f83f52492f"
  end
  go_resource "github.com/jtolds/gls" do
    url "https://github.com/jtolds/gls.git",
      :revision => "f1ac7f4f24f50328e6bc838ca4437d1612a0243c"
  end
  go_resource "github.com/lib/pq" do
    url "https://github.com/lib/pq.git",
      :revision => "19eeca3e30d2577b1761db471ec130810e67f532"
  end
  go_resource "github.com/macaron-contrib/binding" do
    url "https://github.com/macaron-contrib/binding.git",
      :revision => "0fbe4b9707e6eb556ef843e5471592f55ce0a5e7"
  end
  go_resource "github.com/macaron-contrib/session" do
    url "https://github.com/macaron-contrib/session.git",
      :revision => "31e841d95c7302b9ac456c830ea2d6dfcef4f84a"
  end
  go_resource "github.com/mattn/go-sqlite3" do
    url "https://github.com/mattn/go-sqlite3.git",
      :revision => "e28cd440fabdd39b9520344bc26829f61db40ece"
  end
  go_resource "github.com/smartystreets/goconvey/convey" do
    url "https://github.com/smartystreets/goconvey.git",
      :revision => "fbc0a1c888f9f96263f9a559d1769905245f1123"
  end
  go_resource "github.com/streadway/amqp" do
    url "https://github.com/streadway/amqp.git",
      :revision => "150b7f24d6ad507e6026c13d85ce1f1391ac7400"
  end
  go_resource "golang.org/x/net" do
    url "https://go.googlesource.com/net.git",
      :revision => "972f0c5fbe4ae29e666c3f78c3ed42ae7a448b0a"
  end
  go_resource "golang.org/x/oauth2" do
    url "https://go.googlesource.com/oauth2.git",
      :revision => "c58fcf0ffc1c772aa2e1ee4894bc19f2649263b2"
  end
  go_resource "gopkg.in/bufio.v1" do
    url "https://github.com/go-bufio/bufio.git",
      :revision => "567b2bfa514e796916c4747494d6ff5132a1dfce"
  end
  go_resource "gopkg.in/ini.v1" do
    url "https://github.com/go-ini/ini.git",
      :revision => "177219109c97e7920c933e21c9b25f874357b237"
  end
  go_resource "gopkg.in/redis.v2" do
    url "https://github.com/go-redis/redis.git",
      :revision => "e6179049628164864e6e84e973cfb56335748dea"
  end
  go_resource "gopkgs.com/pool.v1" do
    url "https://github.com/rainycape/pool.git",
      :revision => "c850f092aad1780cbffff25f471c5cc32097932a"
  end
  go_resource "gopkgs.com/unidecode.v1" do
    url "https://github.com/rainycape/unidecode.git",
      :revision => "4deae2c05236b41cc39f8144ac87a837ba974d40"
  end

  def install
    ENV["GOBIN"] = bin
    ENV["GOPATH"] = buildpath
    ENV["GOHOME"] = buildpath

    mkdir_p buildpath/"src/github.com/grafana/"
    ln_sf buildpath, buildpath/"src/github.com/grafana/grafana"
    Language::Go.stage_deps resources, buildpath/"src"

    ENV["HOME"] = buildpath/".brew_home"
    ENV.prepend_path "PATH", "#{Formula["node"].opt_libexec}/npm/bin"

    system "npm", "install"
    system "npm", "install", "grunt-cli"
    system "./node_modules/.bin/grunt"

    system "go", "build", "main.go"

    bin.install "main" => "grafana"
  end

  test do
    # pipe_output("#{bin}/vegeta attack -duration=1s -rate=1", "GET http://localhost/")
  end
end
