class Mr < Formula
  desc "Multiple Repository management tool"
  homepage "https://myrepos.branchable.com/"
  url "git://myrepos.branchable.com/", :tag => "1.20151022", :revision => "038088c6b4903ce96c73fd4a99751c9848f98863"

  bottle do
    cellar :any_skip_relocation
    sha256 "fa047bbe29a893475aa0c3b9ae04f4359378b2dd658172ca159f765d6559511e" => :el_capitan
    sha256 "df78b4c53b52fd50a1d1fe0a34c92faeee63792360dafd6b9b31e47f7e47da3d" => :yosemite
    sha256 "9da103695bd2d1cc681efd6101fb8dff4ea0765c669eb932f0b9ff68656808c9" => :mavericks
  end

  resource("test-repo") do
    url "https://github.com/Homebrew/homebrew-command-not-found.git"
  end

  def install
    system "make"
    bin.install "mr", "webcheckout"
    man1.install gzip("mr.1", "webcheckout.1")
    (share/"mr").install Dir["lib/*"]
  end

  test do
    resource("test-repo").stage do
      system bin/"mr", "register"
      assert_match(/^mr status: #{Dir.pwd}$/, shell_output("#{bin}/mr status"))
    end
  end
end
