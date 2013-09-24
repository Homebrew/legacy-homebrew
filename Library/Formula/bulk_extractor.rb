require 'formula'

class BulkExtractor < Formula
  homepage 'https://github.com/simsong/bulk_extractor/wiki'
  url 'http://digitalcorpora.org/downloads/bulk_extractor/bulk_extractor-1.4.0.tar.gz'
  sha1 'b2cc34865e2c0cf4340a56a5f9396457579111b7'

  depends_on :autoconf
  depends_on :automake
  depends_on :python

  depends_on 'afflib' => :optional
  depends_on 'exiv2' => :optional
  depends_on 'libewf' => :optional

  def patches
    # Error in exec install hooks; installing java GUI manually. Reported in
    # https://groups.google.com/group/bulk_extractor-users/browse_thread/thread/ff7cc11e8e6d8e8d
    "https://gist.github.com/raw/3785687/3a61d57539c2b9ecde44121b370db85ff9d4f86e/makefile.in.patch"
  end

  def install

    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make"
    system "make install"

    # Install documentation
    (share/'bulk_extractor/doc').install Dir['doc/*.{html,txt,pdf}']

    python do
      (lib/python.xy/"site-packages").install Dir['python/*.py']
    end

    # Install the GUI the Homebrew way
    libexec.install 'java_gui/BEViewer.jar'
    bin.write_jar_script libexec/"BEViewer.jar", "BEViewer", "-Xmx1g"
  end

  def caveats
    python.standard_caveats if python
  end
end
