require 'formula'

class Forego < Formula
  homepage 'https://github.com/ddollar/forego'
  url 'https://godist.herokuapp.com/projects/ddollar/forego/releases/0.10.0/darwin-amd64/forego'
  sha1 '1abc482cc301674a884248339aee21b45e150310'

  def install
    bin.install "forego"
  end

  test do
    (testpath/"Procfile").write("web: echo hello world")
    system "forego start"
  end

end
