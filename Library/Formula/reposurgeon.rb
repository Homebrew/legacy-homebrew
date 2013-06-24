require 'formula'

class Reposurgeon < Formula
  homepage 'http://www.catb.org/esr/reposurgeon/'
  url 'http://www.catb.org/~esr/reposurgeon/reposurgeon-2.37.tar.gz'
  sha256 '615394319ae16c842cab77b4f1562a53f0fc666ce401a34acb949402424be376'

  depends_on 'asciidoc'
  depends_on 'xmlto'

  def install
    ENV['XML_CATALOG_FILES'] = "#{etc}/xml/catalog"
    system "make"
    tools = %w{reposurgeon repopuller repodiffer}
    bin.install tools
    man1.install tools.map { |m| "#{m}.1" }
  end
end
