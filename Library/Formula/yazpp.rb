require 'formula'

class Yazpp < Formula
  homepage 'http://www.indexdata.com/yazpp'
  url 'http://ftp.indexdata.dk/pub/yazpp/yazpp-1.6.0.tar.gz'
  sha1 'f32900be1f05ca51961e17c44b2a0df4ff54a55b'

  bottle do
    cellar :any
    sha1 "b98f1d4cea546f4a5e1c1de45b5a328745385e6b" => :mavericks
    sha1 "dc99151ef36d0d9ea19089c1597d66fffd827521" => :mountain_lion
    sha1 "80e862d9b9775a351905d13295151fc2eb04ccd8" => :lion
  end

  depends_on 'yaz'

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
