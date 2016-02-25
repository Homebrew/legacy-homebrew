class Hashcash < Formula
  desc "Proof-of-work algorithm to counter denial-of-service (DoS) attacks"
  homepage "http://hashcash.org"
  url "http://hashcash.org/source/hashcash-1.22.tgz"
  sha256 "0192f12d41ce4848e60384398c5ff83579b55710601c7bffe6c88bc56b547896"

  bottle do
    cellar :any_skip_relocation
    sha256 "b9ab067b3001c71dc5cfa3085bfcd204cb4837fd6c87f5ce722bd77b8a629850" => :el_capitan
    sha256 "b9e7653e9f2c14aad3d4f3589bed6de036e78b766bc01be5ae9f24be0d9696c4" => :yosemite
    sha256 "5b34b5d7a14ec55622545d823d7a707fcb7b736a88cc531e82799ef85ff8f494" => :mavericks
  end

  def install
    system "make", "install",
                   "PACKAGER=HOMEBREW",
                   "INSTALL_PATH=#{bin}",
                   "MAN_INSTALL_PATH=#{man1}",
                   "DOC_INSTALL_PATH=#{doc}"
  end

  test do
    system "#{bin}/hashcash", "-mb10", "test@example.com"
  end
end
