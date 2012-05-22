require 'formula'

class AvroC < Formula
  homepage 'http://avro.apache.org/'
  url 'http://www.apache.org/dyn/closer.cgi?path=avro/avro-1.6.3/c/avro-c-1.6.3.tar.gz'
  md5 'af3f15605b47d02719706e5d67de8e75'

  depends_on 'cmake' => :build
  depends_on 'xz'
  depends_on 'asciidoc' if ARGV.include? '--asciidoc'

  def options
  [
    ['--asciidoc', "Enable HTML documentation"],
  ]
  end

  def install
    args = std_cmake_parameters.split + [
             '.',]
    system "cmake", *args
    system "make install"
  end
end
