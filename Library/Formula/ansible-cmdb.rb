class AnsibleCmdb < Formula
  desc "Generates static HTML overview page from Ansible facts"
  homepage "https://github.com/fboender/ansible-cmdb"
  url "https://github.com/fboender/ansible-cmdb/releases/download/1.11/ansible-cmdb-1.11.zip"
  sha256 "6651792bf168fdfadb0e9f0e0404854f10f22ec23fe7b6c2032bc3a3bf846d0f"

  bottle do
    cellar :any_skip_relocation
    sha256 "e886c5b02528a236d41ac50463243993bba9c1a7777f41e9edfdaf9420eaf345" => :el_capitan
    sha256 "771548249a6b1e7526d83ad4ce9a482a138b78095d094347b79ef52e2cc65732" => :yosemite
    sha256 "4822b7270469a352dbc742ac75e659111ad3f841b2b58d68570551298e3de9eb" => :mavericks
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
