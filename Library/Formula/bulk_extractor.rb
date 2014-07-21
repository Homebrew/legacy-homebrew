require 'formula'

class BulkExtractor < Formula
  homepage 'https://github.com/simsong/bulk_extractor/wiki'
  url 'http://digitalcorpora.org/downloads/bulk_extractor/bulk_extractor-1.4.4.tar.gz'
  sha1 'e95ed6db74d9998842089b53eb4322dd0a730a82'

  depends_on 'afflib' => :optional
  depends_on 'exiv2' => :optional
  depends_on 'libewf' => :optional

  # Error in exec install hooks; installing java GUI manually. Reported in
  # https://groups.google.com/group/bulk_extractor-users/browse_thread/thread/ff7cc11e8e6d8e8d
  patch do
    url "https://gist.githubusercontent.com/anarchivist/3785687/raw/3a61d57539c2b9ecde44121b370db85ff9d4f86e/makefile.in.patch"
    sha1 "0b597214c15505d84602a28b74fc01ce5aa0c902"
  end

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make"
    system "make install"

    # Install documentation
    (share/'bulk_extractor/doc').install Dir['doc/*.{html,txt,pdf}']

    (lib/'python2.7/site-packages').install Dir['python/*.py']

    # Install the GUI the Homebrew way
    libexec.install 'java_gui/BEViewer.jar'
    bin.write_jar_script libexec/"BEViewer.jar", "BEViewer", "-Xmx1g"
  end

  test do
    input_file = testpath/"data.txt"
    input_file.write "http://brew.sh\n(201)555-1212\n"

    output_dir = testpath/"output"
    system "#{bin}/bulk_extractor", "-o", output_dir, input_file

    assert (output_dir/"url.txt").read.include?("http://brew.sh")
    assert (output_dir/"telephone.txt").read.include?("(201)555-1212")
  end
end
