require 'brewkit'
 
class Protobuf <Formula
  @url='http://protobuf.googlecode.com/files/protobuf-2.2.0.tar.bz2'
  @homepage='http://code.google.com/p/protobuf/'
  @sha1='a0aff9df8dc93c5337553d586bbe726808d342a6'
 
  def install
    system "./configure", "--prefix=#{prefix}", "--disable-debug", "--disable-dependency-tracking"
    system "make install"
  end
end