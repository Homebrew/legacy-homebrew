require 'formula'

class GitIntegration < Formula
  homepage 'http://johnkeeping.github.io/git-integration/'
  url 'https://github.com/johnkeeping/git-integration/archive/v0.2.zip'
  sha1 'ce86564077a683c8ce270c85530f9100f3f8c950'

  depends_on 'asciidoc' => [:build, :optional]

  def install
    ENV["XML_CATALOG_FILES"] = "#{HOMEBREW_PREFIX}/etc/xml/catalog"
    (buildpath/"config.mak").write("prefix = #{prefix}")
    system "make", "install"
    if build.include? "with-asciidoc"
      system "make", "install-doc"
    end
    system "make", "install-completion"
  end

  test do
    system "#{bin}/git-integration", "--version"
  end
end
