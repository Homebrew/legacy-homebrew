require 'formula'

class Pixz < Formula
  homepage 'https://github.com/vasi/pixz'
  url 'https://downloads.sourceforge.net/project/pixz/pixz-1.0.2.tgz'
  sha1 '953b2b55504ba349f1e7e47bdfcd4165ba206827'

  head 'https://github.com/vasi/pixz.git'

  option 'with-docs', 'Build man pages using asciidoc and DocBook'

  depends_on 'libarchive'
  depends_on 'xz'

  if build.with? 'docs'
    depends_on 'asciidoc' => :build
    depends_on 'docbook' => :build
  end

  def install
    system 'make'
    bin.install 'pixz'

    if build.with? 'docs'
      ENV['XML_CATALOG_FILES'] = "#{HOMEBREW_PREFIX}/etc/xml/catalog"
      system 'a2x --doctype manpage --format manpage pixz.1.asciidoc'
      man1.install 'pixz.1'
    end
  end

  test do
    system "#{bin}/pixz"
  end
end
