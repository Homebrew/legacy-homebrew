require 'formula'

class Cssembed < Formula
  homepage 'http://www.nczonline.net/blog/2009/11/03/automatic-data-uri-embedding-in-css-files/'
  url 'https://github.com/downloads/nzakas/cssembed/cssembed-0.4.5.jar'
  sha1 'c170f4a6a19f2f86ebd04208cc71d017b3a6f907'

  def install
    libexec.install "cssembed-0.4.5.jar"
    bin.write_jar_script libexec/'cssembed-0.4.5', 'cssembed'
  end
end
