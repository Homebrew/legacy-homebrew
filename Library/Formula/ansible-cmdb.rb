class AnsibleCmdb < Formula
  desc "Generates static HTML overview page from Ansible facts"
  homepage "https://github.com/fboender/ansible-cmdb"
  url "https://github.com/fboender/ansible-cmdb/releases/download/1.13/ansible-cmdb-1.13.zip"
  sha256 "02e5e47f71b60f0b0e5f20c01b6dd32f4f0d8acb46af4bd4223cfd28f06faf6c"

  bottle do
    cellar :any_skip_relocation
    sha256 "6731eb5cfcdf608239299eee81d4cf4a41962295cd9acdf57456f83dedd128de" => :el_capitan
    sha256 "6a4cae4e4403e590b6c077de5cc6d9776df59893ebaa4ac75a8c902ccbdd4df1" => :yosemite
    sha256 "d8c3201e440ae754b3ef03db4cd978d791aecb335e8cf4611ed8125550da4daf" => :mavericks
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
