class AnsibleCmdb < Formula
  desc "Generates static HTML overview page from Ansible facts"
  homepage "https://github.com/fboender/ansible-cmdb"
  url "https://github.com/fboender/ansible-cmdb/releases/download/1.10/ansible-cmdb-1.10.zip"
  sha256 "9234f77624ba174721ef8d0ecd2717d73fc3a1e9393a65289be29f08ec4b370e"

  bottle do
    cellar :any_skip_relocation
    sha256 "dd538aa11b1da2d7964f77be287b9fda56598c350f7554591d6f87a51757e12b" => :el_capitan
    sha256 "22c377a50ae1a605e8065a6d143a1161e7d9eb765a706502e1b0913cd1730826" => :yosemite
    sha256 "2329fc84c3705bde7664138dafc116f5bcc4816cab5d10ba8cdbb501edd140ed" => :mavericks
  end

  depends_on :python if MacOS.version <= :snow_leopard
  depends_on "libyaml"

  def install
    bin.mkpath
    man1.mkpath
    inreplace "Makefile" do |s|
      s.gsub! "/usr/local/lib/${PROG}", prefix
      s.gsub! "/usr/local/bin", bin
      s.gsub! "/usr/local/share/man/man1/", man1 + 'ansible-cmdb.1'
      s.gsub! "mandb", "#mandb"
    end
    system "make", "install"
  end

  test do
    (testpath/"hosts").write <<-EOS.undent
[brew_test]
brew1   dtap=dev  comment='Old database server'
brew2   dtap=dev  comment='New database server'
      EOS
    system "#{bin}/ansible-cmdb", "-dt", "html_fancy", "."
  end
end
