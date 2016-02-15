class AnsibleCmdb < Formula
  desc "Generates static HTML overview page from Ansible facts"
  homepage "https://github.com/fboender/ansible-cmdb"
  url "https://github.com/fboender/ansible-cmdb/releases/download/1.12/ansible-cmdb-1.12.zip"
  sha256 "dbc915971bc5477e079bc77a1983c73cd7363312a86ae9747ad477a06ac750b5"

  bottle do
    cellar :any_skip_relocation
    sha256 "60d855a879e67feb27b13db40b56d6aee572c569d79f7fcc02605a9e5cafb67b" => :el_capitan
    sha256 "313d00f965fc591d1211e7a4c76120b002e7fe5a7a85b4678303b90783108c33" => :yosemite
    sha256 "24e4ddd06548a1bd59e5994dfdab9f751e4c0acfc9ff5042169816e3d2fb91bd" => :mavericks
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
