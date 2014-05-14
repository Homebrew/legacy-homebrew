require 'formula'

class DiffPdf < Formula
  homepage 'http://vslavik.github.io/diff-pdf/'
  url 'https://github.com/vslavik/diff-pdf/archive/v0.2.tar.gz'
  sha1 '308ea8e92ac609ca88303dce6a6e8403c6b9f11f'

  version '0.2'

  depends_on 'pkg-config' => :build
  depends_on 'automake'
  depends_on :x11
  depends_on 'wxwidgets'
  depends_on 'cairo'
  depends_on 'poppler' => 'with-glib'

  def install
    system './bootstrap'

    system './configure', '--disable-debug',
           '--disable-dependency-tracking',
           '--disable-silent-rules',
           "--prefix=#{prefix}"

    system 'make'
    system 'make', 'install'
  end

  test do
    system "#{bin}/diff-pdf", '-h'
  end
end
