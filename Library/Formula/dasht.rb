class Dasht < Formula
  desc "Search API docs offline, in your terminal or browser"
  homepage "https://sunaku.github.io/dasht"
  url "https://github.com/sunaku/dasht/archive/v1.1.0.tar.gz"
  sha256 "578bb8a1d576b5c487ca3d0c3113905ff68401530d4237f239b6c6aac62e1fbd"

  bottle :unneeded

  depends_on "sqlite"

  def install
    bin.install Dir["bin/*"]
  end

  def post_install
    puts "First, install some docsets using dasht-docsets-install(1)"
    puts "\t dasht-docsets-install bash"
    puts "Next, perform a direct search from the terminal using dasht(1)"
    puts "\t dasht 'c - x'"
    puts "Then, repeat the search in a web browser using dasht-server(1)"
    puts "\t dasht-server"
  end

  test do
    system "#{bin}/dasht"
  end
end
