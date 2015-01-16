class Wren < Formula
  homepage "https://munificent.github.io/wren/index.html"
  url "https://github.com/munificent/wren/archive/master.tar.gz"
  sha1 "00dbc1ec0dc96009be4860a5be52abd51ed68c58"
  version "0.1"

  def install
    system "make" 
    bin.install "wren"
  end

  test do
    File.open('test.wren', 'w') do |f| 
       f.puts "IO.print(\"Hello, World!\")"
    end 
    system "#{bin}/wren", "test.wren"
  end
end
