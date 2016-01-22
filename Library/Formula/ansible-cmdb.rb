class AnsibleCmdb < Formula
  desc "Generates static HTML overview page from Ansible facts"
  homepage "https://github.com/fboender/ansible-cmdb"
  url "https://github.com/fboender/ansible-cmdb/releases/download/1.11/ansible-cmdb-1.11.zip"
  sha256 "6651792bf168fdfadb0e9f0e0404854f10f22ec23fe7b6c2032bc3a3bf846d0f"

  bottle do
    cellar :any_skip_relocation
    sha256 "9c6651a0472fd94a4ad51a92e774f0a847cb485c079aa00585652b91566f0cb5" => :el_capitan
    sha256 "d3109325562f0ec28d87a121f6973be17fb82c6fce9d02ea56eea88a67159a45" => :yosemite
    sha256 "eac9c9547d13b240e225cad6582a111f150cf9a81b2ab7cb42c03dddc9dc2af7" => :mavericks
  end

  depends_on :python if MacOS.version <= :snow_leopard
  depends_on "libyaml"

  def install
    bin.mkpath
    man1.mkpath
    inreplace "Makefile" do |s|
      s.gsub! "/usr/local/lib/${PROG}", prefix
      s.gsub! "/usr/local/bin", bin
      s.gsub! "/usr/local/share/man/man1", man1
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
